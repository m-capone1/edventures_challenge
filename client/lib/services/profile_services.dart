import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ProfileService {
  final String url = "https://edventures-challenge.onrender.com/api";

  Future<List<UserProfile>> fetchProfiles() async {
    final response = await http.get(Uri.parse('$url/user-profiles/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<UserProfile> profiles =
          jsonResponse.map((profile) => UserProfile.fromJson(profile)).toList();
      return profiles;
    } else {
      throw Exception('Unable to load profiles');
    }
  }

  Future<void> createProfile(UserProfile profile) async {
    final response = await http.post(
      Uri.parse('$url/user-profiles/'),
      body: jsonEncode(profile.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to create profile: ${response.body}');
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    final response = await http.put(
      Uri.parse('$url/user-profiles/${profile.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Unable to update profile');
    } else {
      logger.i('Profile updated: ${response.statusCode}, ${response.body}');
    }
  }

  Future<void> deleteProfile(int id) async {
    final response =
        await http.delete(Uri.parse('$url/user-profiles/${id.toString()}/'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Unable to delete profile');
    }
  }
}
