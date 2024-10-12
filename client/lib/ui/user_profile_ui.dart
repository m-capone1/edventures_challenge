import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../services/profile_services.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profiles')),
      body: BlocProvider(
        create: (context) => ProfileBloc(ProfileService())..add(LoadProfiles()),
        child: const ProfileListView(),
      ),
    );
  }
}

class ProfileListView extends StatelessWidget {
  const ProfileListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
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
                subtitle: Text(profile.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Implement edit
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(DeleteProfile(profile.id));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        } else if (state is ProfileError) {
          return Center(child: Text('Failed to load profiles: ${state.error}'));
        } else {
          return const Center(child: Text('No profiles found.'));
        }
      },
    );
  }
}
