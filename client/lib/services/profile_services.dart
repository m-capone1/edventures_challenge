import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';

class ProfileService {
  final String url = "http://127.0.0.1:8000/api";

  Future<List<UserProfile>> fetchProfiles() async {
    final response = await http.get(Uri.parse('$url/user-profiles/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((profile) => UserProfile.fromJson(profile))
          .toList();
    } else {
      throw Exception('Unable to load profiles');
    }
  }

  Future<void> createProfile(UserProfile profile) async {
    final response = await http.post(
      Uri.parse('$url/user-profiles/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Unable to create profile');
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    final response = await http.put(
      Uri.parse('$url/user-profiles/${profile.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );
    if (response.statusCode != 200) {
      print('Response Body: ${response.body}');
      throw Exception('Unable to update profile');
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
