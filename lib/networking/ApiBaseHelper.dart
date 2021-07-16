import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart' as http;
import 'package:optica/widgets/MyAlertDialog.dart';
import 'dart:convert';
import 'dart:async';
import 'ApiExceptions.dart';

class ApiBaseHelper {
  String baseUrl;

  ApiBaseHelper({required this.baseUrl});

  Future<dynamic> get(String endpoint, String? token, String? identifier, BuildContext context) async {
    print('[GET] $endpoint');
    var responseJson;
    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.acceptHeader: 'application/json',
          },
        );

        responseJson = _returnResponse(response, identifier, context);
      } else {
        final response = await http.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
          }
        );
        responseJson = _returnResponse(response, null, context);
      }
    } on SocketException {
      MyDialog(
        context: context,
        alertTitle: 'Conexión Fallida',
        alertContent: 'Por favor, revise su conexión\na internet',
        buttonText: 'Ok',
        buttonAction: () => Navigator.pop(context)
      ).createDialog();
      throw FetchDataException('No Internet connection');
    }
    print('GET Recieved!');
    return responseJson;
  }

  Future<dynamic> post(String endpoint, String? identifier, String? token, String postBody, BuildContext context) async {
    print('[POST] $endpoint');
    var responseJson;
    try {
      if(token != null) {
        final response = await http.post(
          Uri.parse('$baseUrl$endpoint'),
          body: postBody,
          headers: {
            HttpHeaders.authorizationHeader : 'Bearer $token',
            HttpHeaders.contentTypeHeader : 'application/json',
          }
        );
        responseJson = _returnResponse(response, identifier, context);
      } else {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        body: postBody,
        headers: {
          HttpHeaders.contentTypeHeader : 'application/json',
        }
      );
      responseJson = _returnResponse(response, identifier, context);
      }
      
    } on SocketException {
      MyDialog(
        context: context,
        alertTitle: 'Conexión Fallida',
        alertContent: 'Por favor, revise su conexión\na internet',
        buttonText: 'Ok',
        buttonAction: () => Navigator.pop(context)
      ).createDialog();
      throw FetchDataException('No Internet Connection');
    }
    print('POST Recieved!');
    return responseJson;
  }

  dynamic _returnResponse(http.Response response, String? identifier, BuildContext context) {
    if (identifier == 'isTokenExpired') {
      if (response.statusCode == 200) {
        return false;
      } else {
        return true;
      }
      
    }

    switch (response.statusCode) {
      case 200:
        if (identifier == 'confirmEnvio' || identifier == 'informEnvio') {
          return 200;
        }
        String stringResponse = Utf8Decoder().convert(response.bodyBytes);
        var responseJson = jsonDecode(stringResponse);
        print(responseJson);
        return responseJson;
      case 204:
        if (identifier == 'confirmEnvio' || identifier == 'informEnvio') {
          return 204;
        }
        var responseJson = jsonDecode(response.body);
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString(), 400);
      case 401:
        if (identifier == 'token') {
          MyDialog(
            context: context,
            alertTitle: 'Inicio de sesión fallido',
            alertContent: 'Usuario y/o Contraseña incorrectos',
            buttonText: 'Ok',
            buttonAction: () => Phoenix.rebirth(context)
          ).createDialog();
        }
        throw UnauthorizedException('Failed to authenticate', 401);
      case 500:
        if (identifier == 'confirmEnvio' || identifier == 'informEnvio') {
          return 500;
        }
        MyDialog(
          context: context,
          alertTitle: 'Error Interno del Servidor',
          alertContent:
              'Se produjo un error en el servidor,\nasegúrese de tener una conexión\nestable a internet.\nVuelva a intentar más tarde',
          buttonText: 'Ok',
          buttonAction: () => Navigator.pop(context)
        ).createDialog();
        throw InternalServerException(response.body.toString(), 500);
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}', 500);
    }
  }
}
