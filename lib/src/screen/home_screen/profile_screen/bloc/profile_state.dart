part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final String name;
  final String phone;
  final String email;
  final String picture;
  final String gender;
  final String dateOfBirth;

  ProfileLoaded({
    required this.name,
    required this.phone,
    required this.email,
    required this.picture,
    required this.gender,
    required this.dateOfBirth,
  });
}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

final class ProfileUpdateSuccess extends ProfileState {}

