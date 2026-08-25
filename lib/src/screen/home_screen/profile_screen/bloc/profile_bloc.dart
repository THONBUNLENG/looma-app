
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../../../manager/profile_manager.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileManager _profileManager = ProfileManager();

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    emit(ProfileLoading());
    try {
      emit(ProfileLoaded(
        name: _profileManager.name,
        phone: _profileManager.phone,
        email: _profileManager.email,
        picture: _profileManager.picture,
        gender: _profileManager.gender,
        dateOfBirth: _profileManager.dateOfBirth,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _profileManager.updateProfile(
        name: event.name,
        phone: event.phone,
        email: event.email,
        picture: event.picture,
        gender: event.gender,
        dateOfBirth: event.dateOfBirth,
      );
      
      emit(ProfileUpdateSuccess());
      
      // Reload profile after update
      emit(ProfileLoaded(
        name: _profileManager.name,
        phone: _profileManager.phone,
        email: _profileManager.email,
        picture: _profileManager.picture,
        gender: _profileManager.gender,
        dateOfBirth: _profileManager.dateOfBirth,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
