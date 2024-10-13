import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class EditProfileForm extends StatefulWidget {
  final UserProfile profile;

  const EditProfileForm({super.key, required this.profile});

  @override
  EditProfileFormState createState() => EditProfileFormState();
}

class EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String firstName;
  late String lastName;
  late String email;

  @override
  void initState() {
    super.initState();
    username = widget.profile.username;
    firstName = widget.profile.firstName;
    lastName = widget.profile.lastName;
    email = widget.profile.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: username,
                decoration: const InputDecoration(labelText: 'Username'),
                onChanged: (value) => username = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
                onChanged: (value) => firstName = value,
              ),
              TextFormField(
                initialValue: lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
                onChanged: (value) => lastName = value,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    UserProfile updatedProfile = UserProfile(
                      id: widget.profile.id,
                      username: username,
                      firstName: firstName,
                      lastName: lastName,
                      email: email,
                    );

                    logger.i('Updated Profile: ${updatedProfile.toJson()}');

                    BlocProvider.of<ProfileBloc>(context)
                        .add(UpdateProfile(updatedProfile));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
