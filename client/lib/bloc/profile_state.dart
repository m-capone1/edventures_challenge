import '../models/user_profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final List<UserProfile> profiles;

  ProfileLoaded(this.profiles);
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}
