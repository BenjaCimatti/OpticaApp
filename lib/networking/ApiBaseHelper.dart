import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart' as http;
import 'package:optica/widgets/MyDialog.dart';
import 'dart:convert';
import 'dart:async';
import 'ApiExceptions.dart';

class ApiBaseHelper {
  String baseUrl;

  ApiBaseHelper({required this.baseUrl});

  Future<dynamic> get(String endpoint, String? token, queryParameter,BuildContext context) async {
    print('[GET] $endpoint');
    var responseJson;
    try {
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParameter),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        );
        responseJson = _returnResponse(response, null, context);
      } else {
        final response = await http.get(
          Uri.parse('$baseUrl$endpoint'),
        );
        responseJson = _returnResponse(response, null, context);
      }
    } on SocketException {
      MyDialog(
          context: context,
          alertTitle: 'Conexión Fallida',
          alertContent: 'Por favor, revise su conexión\na internet',
          buttonText: 'Reiniciar Aplicación',
          buttonAction: () => Phoenix.rebirth(context)).createDialog();
      throw FetchDataException('No Internet connection');
    }
    print('GET Recieved!');
    return responseJson;
  }

  Future<dynamic> post(String endpoint, String? identifier, String postBody,
      BuildContext context) async {
    print('[POST] $endpoint');
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        body: postBody,
        headers: {
          HttpHeaders.contentTypeHeader : 'application/json',
        }
      );
      responseJson = _returnResponse(response, identifier, context);
    } on SocketException {
      MyDialog(
          context: context,
          alertTitle: 'Conexión Fallida',
          alertContent: 'Por favor, revise su conexión\na internet',
          buttonText: 'Reiniciar Aplicación',
          buttonAction: () => Phoenix.rebirth(context)).createDialog();
      throw FetchDataException('No Internet Connection');
    }
    print('POST Recieved!');
    return responseJson;
  }

  dynamic _returnResponse(
      http.Response response, String? identifier, BuildContext context) {
    switch (response.statusCode) {
      case 200:
        String stringResponse = Utf8Decoder().convert(response.bodyBytes);
        var responseJson = jsonDecode(stringResponse);
        print(responseJson);
        return responseJson;
      case 204:
        var responseJson = jsonDecode(response.body);
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        if (identifier == 'token') {
          MyDialog(
              context: context,
              alertTitle: 'Inicio de sesión fallido',
              alertContent: 'Usuario y/o Contraseña incorrectos',
              buttonText: 'Ok',
              buttonAction: () => Phoenix.rebirth(context)).createDialog();
        } else if (identifier == 'envios') {}
        throw UnauthorizedException(response.body.toString());
      case 500:
        MyDialog(
            context: context,
            alertTitle: 'Error Interno del Servidor',
            alertContent:
                'Se produjo un error en el servidor,\nasegúrese de tener una conexión\nestable a internet.\nVuelva a intentar más tarde',
            buttonText: 'Reiniciar Aplicación',
            buttonAction: () => Phoenix.rebirth(context)).createDialog();
        throw InternalServerException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
