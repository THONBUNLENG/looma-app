part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class GoogleSignInRequested extends LoginEvent {}

class AppleSignInRequested extends LoginEvent {}

class FacebookSignInRequested extends LoginEvent {}

class SendOtpRequested extends LoginEvent {
  final String phone;
  final String name;
  final String? password;
  final File? imageFile;

  SendOtpRequested({
    required this.phone,
    required this.name,
    this.password,
    this.imageFile,
  });
}

class VerifyOtpRequested extends LoginEvent {
  final String verificationId;
  final String smsCode;
  final String name;
  final String phone;
  final String? password;
  final File? imageFile;

  VerifyOtpRequested({
    required this.verificationId,
    required this.smsCode,
    required this.name,
    required this.phone,
    this.password,
    this.imageFile,
  });
}

class RegisterRequested extends LoginEvent {
  final String email;
  final String password;
  final String name;
  final String? phone;
  final File? imageFile;

  RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
    this.imageFile,
  });
}

class _InternalOtpSent extends LoginEvent {
  final String verificationId;
  _InternalOtpSent(this.verificationId);
}

class _InternalLoginFailure extends LoginEvent {
  final String error;
  _InternalLoginFailure(this.error);
}

class _InternalVerificationCompleted extends LoginEvent {
  final AuthCredential credential;
  final String name;
  final String? password;
  final String phone;
  final File? imageFile;

  _InternalVerificationCompleted({
    required this.credential,
    required this.name,
    this.password,
    required this.phone,
    this.imageFile,
  });
}

