import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../services/profile_services.dart';
import './create_profile_form.dart';
import './edit_profile_form.dart';
import './ai_chat.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(LoadProfiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profiles'),
        actions: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: const Icon(Icons.chat_outlined, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AiChat()),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 24),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateProfileForm()),
                    );
                    if (mounted) {
                      BlocProvider.of<ProfileBloc>(context).add(LoadProfiles());
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => ProfileBloc(ProfileService())..add(LoadProfiles()),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return ListView.builder(
                itemCount: state.profiles.length,
                itemBuilder: (context, index) {
                  final profile = state.profiles[index];
                  return ListTile(
                    title: Text(profile.username),
                    subtitle: Text(
                        '${profile.firstName}, ${profile.lastName}, ${profile.email}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            if (!mounted) return;

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileForm(profile: profile),
                              ),
                            );
                            if (mounted && result != null) {
                              BlocProvider.of<ProfileBloc>(context)
                                  .add(LoadProfiles());
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            final profileId = profile.id;
                            BlocProvider.of<ProfileBloc>(context)
                                .add(DeleteProfile(profileId));
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is ProfileError) {
              return Center(
                  child: Text('Failed to load profiles: ${state.error}'));
            } else {
              return const Center(child: Text('No profiles found.'));
            }
          },
        ),
      ),
    );
  }
}
