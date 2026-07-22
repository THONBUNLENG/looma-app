part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final String username;
  LoginSuccess(this.username);
}

final class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
