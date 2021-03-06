import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laboratorio_elena/models/EnvioConfirmado.dart';
import 'package:laboratorio_elena/networking/ApiBaseHelper.dart';

class EnvioConfirmadoRepository {

  // Class Atributes
  String baseUrl; 

  // Class Constructor
  EnvioConfirmadoRepository(
    {
      required this.baseUrl,
    }
  );

  late String _postBody;
  late ApiBaseHelper _helper = ApiBaseHelper(baseUrl: baseUrl);

  Future<int> confirmEnvio(int idEnvio, double geoLatitud, double geoLongitud, String token, BuildContext context) async {

    _postBody = jsonEncode(EnvioConfirmado(
      idEnvio: idEnvio,
      geoLatitud: geoLatitud,
      geoLongitud: geoLongitud
    ).toJson());
    
    final response = await _helper.post('/api/Envios/Confirmar', 'confirmEnvio', token, _postBody, context);
    return response;
  }
}