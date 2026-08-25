part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String? name;
  final String? phone;
  final String? email;
  final String? gender;
  final String? dateOfBirth;
  final String? picture;

  UpdateProfileEvent({
    this.name,
    this.phone,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.picture,
  });
}

