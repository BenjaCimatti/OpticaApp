import 'dart:convert';

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

  Future<Token> getToken(String username, String password, int idOrg, BuildContext context) async { // Sends credentials to the API and receives a JWT
    _postBody = jsonEncode(<String, dynamic>{
      'NombreUsuario': username,
      'Clave': password,
      'IdOrganizacion': idOrg
    });

    print(_postBody);
    
    final response = await _helper.post('/api/Token/Get', 'token', null, _postBody, context);
    return Token.fromJson(response);
  }

  Future<bool> isTokenExpired(String token, BuildContext context) async {

    final bool response = await _helper.get('/api/Token/Verify', token, 'isTokenExpired', context);

    print(response);

    return response;
  }

  Future<Token> renewToken(String token, BuildContext context) async {

    final response = await _helper.get('/api/Token/Renew', token, 'renewToken', context);
    return Token.fromJson(response);
  }
}