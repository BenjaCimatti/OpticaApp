import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:optica/widgets/InvalidCredentials.dart';
import 'package:optica/widgets/NoInternet.dart';
import 'package:optica/widgets/StatusCode500.dart';
import 'dart:convert';
import 'dart:async';
import 'ApiExceptions.dart';

class ApiBaseHelper {
  String baseUrl;

  ApiBaseHelper({
    required this.baseUrl
  });

  Future<dynamic> get(String endpoint, BuildContext context) async {
    print('[GET] $endpoint');
    var responseJson;
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      responseJson = _returnResponse(response, null, context);
    } on SocketException {
      NoInternet().createDialog(context);
      throw FetchDataException('No Internet connection');
    }
    print('GET Recieved!');
    return responseJson;
  }

  Future<dynamic> post(String endpoint, String? identifier, String postBody, BuildContext context) async {
    print('[POST] $endpoint');
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        body: postBody,
      );
      responseJson = _returnResponse(response, identifier, context);
    } on SocketException {
      NoInternet().createDialog(context);
      throw FetchDataException('No Internet Connection');
    }
    print('POST Recieved!');
    return responseJson;
  }

  dynamic _returnResponse(http.Response response, String? identifier, BuildContext context) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        if (identifier == 'token') {
          InvalidCredentials().createDialog(context);
        } else if (identifier == 'envios') {

        }
        throw UnauthorizedException(response.body.toString());
      case 403:
      case 500:
        StatusCode500().createDialog(context);
        throw InternalServerException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  
    }
  }
}