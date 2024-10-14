import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String url = "https://edventures-challenge.onrender.com/api/chat/";

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['response'];
    } else {
      throw Exception('Unable to send message');
    }
  }
}
