import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
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
    print('Api Get, url $endpoint');
    var responseJson;
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      responseJson = _returnResponse(response, context);
    } on SocketException {
      NoInternet().createDialog(context);
      throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  dynamic _returnResponse(http.Response response, BuildContext context) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
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