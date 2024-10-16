import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/profile_services.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;

  ProfileBloc(this.profileService) : super(ProfileInitial()) {
    on<LoadProfiles>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profiles = await profileService.fetchProfiles();
        emit(ProfileLoaded(profiles));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<CreateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        await profileService.createProfile(event.profile);

        final updatedProfiles = await profileService.fetchProfiles();
        emit(ProfileLoaded(updatedProfiles));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        await profileService.updateProfile(event.profile);

        final updatedProfiles = await profileService.fetchProfiles();
        emit(ProfileLoaded(updatedProfiles));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<DeleteProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        await profileService.deleteProfile(event.profileId);
        add(LoadProfiles());
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
