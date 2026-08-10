import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../../network/datastor/auth_login_service.dart';
import '../../../network/datastor/auth_service.dart';
import '../../../utils/firebase_error_handler.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthLoginService _authLoginService = AuthLoginService();

  LoginBloc() : super(LoginInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
    on<FacebookSignInRequested>(_onFacebookSignInRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<_InternalOtpSent>(_onInternalOtpSent);
    on<_InternalLoginFailure>(_onInternalLoginFailure);
    on<_InternalVerificationCompleted>(_onInternalVerificationCompleted);
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      await _authLoginService.verifyPhoneNumber(
        phoneNumber: event.phone,
        onCodeSent: (verificationId) {
          if (!isClosed) add(_InternalOtpSent(verificationId));
        },
        onVerificationFailed: (e) {
          if (!isClosed) add(_InternalLoginFailure(e.message ?? "Verification failed"));
        },
        onVerificationCompleted: (credential) {
          if (!isClosed) {
            add(_InternalVerificationCompleted(
              credential: credential,
              name: event.name,
              password: event.password,
              phone: event.phone,
              imageFile: event.imageFile,
            ));
          }
        },
      );
    } catch (e) {
      emit(LoginFailure(FirebaseErrorHandler.getErrorMessage(e)));
    }
  }

  // Internal events to bridge callbacks to bloc stream
  Future<void> _onInternalOtpSent(_InternalOtpSent event, Emitter<LoginState> emit) async {
    emit(OtpSentState(event.verificationId));
  }

  Future<void> _onInternalLoginFailure(_InternalLoginFailure event, Emitter<LoginState> emit) async {
    emit(LoginFailure(event.error));
  }

  Future<void> _onInternalVerificationCompleted(
    _InternalVerificationCompleted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(event.credential);
      if (userCredential.user != null) {
        final user = userCredential.user!;
        String? photoUrl;

        if (event.imageFile != null) {
          photoUrl = await _authLoginService.uploadProfilePicture(user.uid, event.imageFile!);
        }

        await user.updateDisplayName(event.name);
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }

        // Save to Firestore
        await _authLoginService.saveUserData(
          uid: user.uid,
          name: event.name,
          phone: event.phone,
          photoUrl: photoUrl,
          password: event.password,
        );

        await AuthService.saveLoginData(
          username: event.name,
          phone: event.phone,
          picture: photoUrl,
          token: await user.getIdToken(),
        );

        emit(LoginSuccess(event.name));
      }
    } catch (e) {
      emit(LoginFailure(FirebaseErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final userCredential = await _authLoginService.signInWithOTP(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
      );

      if (userCredential != null && userCredential.user != null) {
        final user = userCredential.user!;
        String? photoUrl;

        if (event.imageFile != null) {
          photoUrl = await _authLoginService.uploadProfilePicture(user.uid, event.imageFile!);
        }

        await user.updateDisplayName(event.name);
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }

        // Save to Firestore
        await _authLoginService.saveUserData(
          uid: user.uid,
          name: event.name,
          phone: event.phone,
          photoUrl: photoUrl,
          password: event.password,
        );

        await AuthService.saveLoginData(
          username: event.name,
          phone: event.phone,
          picture: photoUrl,
          token: await user.getIdToken(),
        );

        emit(LoginSuccess(event.name));
      } else {
        emit(LoginFailure("OTP verification failed."));
      }
    } catch (e) {
      emit(LoginFailure(FirebaseErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final userCredential = await _authLoginService.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential != null && userCredential.user != null) {
        final user = userCredential.user!;
        String? photoUrl;

        if (event.imageFile != null) {
          photoUrl = await _authLoginService.uploadProfilePicture(user.uid, event.imageFile!);
        }

        await user.updateDisplayName(event.name);
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }

        // Save to Firestore
        await _authLoginService.saveUserData(
          uid: user.uid,
          name: event.name,
          email: event.email,
          photoUrl: photoUrl,
          password: event.password,
        );

        await user.sendEmailVerification();

        await AuthService.saveLoginData(
          username: event.name,
          phone: event.phone ?? "",
          picture: photoUrl,
          token: await user.getIdToken(),
        );

        emit(LoginSuccess(event.name));
      } else {
        emit(LoginFailure("Account creation failed."));
      }
    } catch (e) {
      emit(LoginFailure(FirebaseErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final UserCredential? userCredential = await _authLoginService.signInWithGoogle();
      if (userCredential != null && userCredential.user != null) {
        final User user = userCredential.user!;
        await AuthService.saveLoginData(
          username: user.displayName ?? "User",
          phone: user.phoneNumber ?? "",
          picture: user.photoURL,
          token: await user.getIdToken(),
        );
        emit(LoginSuccess(user.displayName ?? "User"));
      } else {
        emit(LoginFailure("Google Sign-In canceled or failed."));
      }
    } catch (e) {
      emit(LoginFailure(FirebaseErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> _onAppleSignInRequested(
    AppleSignInRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final UserCredential? userCredential = await _authLoginService.signInWithApple();
      if (userCredential != null && userCredential.user != null) {
        final User user = userCredential.user!;
        await AuthService.saveLoginData(
          username: user.displayName ?? "User",
          phone: user.phoneNumber ?? "",
          picture: user.photoURL,
          token: await user.getIdToken(),
        );
        emit(LoginSuccess(user.displayName ?? "User"));
      } else {
        emit(LoginFailure("Apple Sign-In canceled or failed."));
      }
    } catch (e) {
      emit(LoginFailure(FirebaseErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> _onFacebookSignInRequested(
    FacebookSignInRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final UserCredential? userCredential = await _authLoginService.signInWithFacebook();
      if (userCredential != null && userCredential.user != null) {
        final User user = userCredential.user!;
        await AuthService.saveLoginData(
          username: user.displayName ?? "User",
          phone: user.phoneNumber ?? "",
          picture: user.photoURL,
          token: await user.getIdToken(),
        );
        emit(LoginSuccess(user.displayName ?? "User"));
      } else {
        emit(LoginFailure("Facebook Sign-In canceled or failed."));
      }
    } catch (e) {
      emit(LoginFailure(FirebaseErrorHandler.getErrorMessage(e)));
    }
  }
}
