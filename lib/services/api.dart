import 'package:http/http.dart' as http;
import 'package:optica/models/version.dart';
import 'dart:convert';

class ApiHandler {

  // Class Atributes
  String apiUrl; 

  // Class Constructor
  ApiHandler(
    {
      required this.apiUrl,
    }
  );

  Future<Version> getVersion() async { // Gets Version from the API
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/Version/Get'));
      if (response.statusCode == 200) {
        return Version.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load version');
      }
    } catch (e) { // Need to fix the exception, dunno why it doesn't work
      throw Exception(e);
    }
  }
}