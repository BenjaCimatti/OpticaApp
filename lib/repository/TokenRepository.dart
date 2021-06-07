import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:optica/models/Token.dart';
import 'package:optica/networking/ApiBaseHelper.dart';

class TokenRepository {

  // Class Atributes
  String baseUrl; 

  // Class Constructor
  TokenRepository(
    {
      required this.baseUrl,
    }
  );

  late String _postBody;
  late ApiBaseHelper _helper = ApiBaseHelper(baseUrl: baseUrl);

  Future<Token> getToken(String username, String password, BuildContext context) async { // Sends credentials to the API and receives a JWT
    _postBody = jsonEncode(<String, String>{
      'username': username,
      'password': password,
    });

    print(_postBody);
    
    final response = await _helper.post('/api/Token/Get', 'token', _postBody, context);
    return Token.fromJson(response);
  }
}