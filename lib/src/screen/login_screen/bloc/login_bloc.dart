import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../../network/datastor/auth_login_service.dart';
import '../../../network/datastor/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthLoginService _authLoginService = AuthLoginService();

  LoginBloc() : super(LoginInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
    on<FacebookSignInRequested>(_onFacebookSignInRequested);
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
      emit(LoginFailure(e.toString()));
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
      emit(LoginFailure(e.toString()));
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
      emit(LoginFailure(e.toString()));
    }
  }
}
