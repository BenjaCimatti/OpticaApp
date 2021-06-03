import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'ApiExceptions.dart';

class ApiBaseHelper {
  String baseUrl;

  ApiBaseHelper({
    required this.baseUrl
  });

  Future<dynamic> get(String endpoint) async {
    print('Api Get, url $endpoint');
    var responseJson;
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  
    }
  }
}