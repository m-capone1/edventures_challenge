import '../models/user_profile.dart';

abstract class ProfileEvent {}

class LoadProfiles extends ProfileEvent {}

class CreateProfile extends ProfileEvent {
  final UserProfile profile;

  CreateProfile(this.profile);
}

class UpdateProfile extends ProfileEvent {
  final UserProfile profile;

  UpdateProfile(this.profile);
}

class DeleteProfile extends ProfileEvent {
  final int profileId;

  DeleteProfile(this.profileId);
}
