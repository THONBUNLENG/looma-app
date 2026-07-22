part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class GoogleSignInRequested extends LoginEvent {}

class AppleSignInRequested extends LoginEvent {}

class FacebookSignInRequested extends LoginEvent {}
