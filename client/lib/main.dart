import 'package:flutter/material.dart';
import '../ui/user_profile_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/profile_services.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ProfileBloc(ProfileService())..add(LoadProfiles()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserProfileScreen(),
    );
  }
}
