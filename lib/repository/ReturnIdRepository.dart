import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laboratorio_elena/models/ReturnId.dart';
import 'package:laboratorio_elena/models/ReturningEnvio.dart';
import 'package:laboratorio_elena/networking/ApiBaseHelper.dart';

class ReturnIdRepository {

  // Class Atributes
  String baseUrl; 

  // Class Constructor
  ReturnIdRepository(
    {
      required this.baseUrl,
    }
  );

  late String _postBody;
  late ApiBaseHelper _helper = ApiBaseHelper(baseUrl: baseUrl);

  ReturnId returnIdFromJson(String str) => ReturnId.fromJson(json.decode(str));

  Future<ReturnId> returnEnvio(int idCliente, double geoLatitud, double geoLongitud, String token, BuildContext context) async {

    _postBody = jsonEncode(ReturningEnvio(
      idCliente: idCliente,
      geoLatitud: geoLatitud,
      geoLongitud: geoLongitud
    ).toJson());
    
    final response = await _helper.post('/api/Retornos/Ingresar', 'returnEnvio', token, _postBody, context);
    final returnId = returnIdFromJson(jsonEncode(response));
    return returnId;
  }
}