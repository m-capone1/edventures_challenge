import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/profile_services.dart';
import 'profile_event.dart';
import 'profile_state.dart';

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
      try {
        await profileService.createProfile(event.profile);
        add(LoadProfiles());
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      try {
        await profileService.updateProfile(event.profile);
        add(LoadProfiles());
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
