import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';

class ProfileService {
  final String url = "http://your-django-backend-url.com/api";

  Future<List<UserProfile>> fetchProfiles() async {
    final response = await http.get(Uri.parse('$url/profiles/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((profile) => UserProfile.fromJson(profile))
          .toList();
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  Future<void> createProfile(UserProfile profile) async {
    final response = await http.post(
      Uri.parse('$url/profiles/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create profile');
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    final response = await http.put(
      Uri.parse('$url/profiles/${profile.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  Future<void> deleteProfile(int id) async {
    final response = await http.delete(Uri.parse('$url/profiles/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete profile');
    }
  }
}
