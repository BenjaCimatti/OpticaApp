import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laboratorio_elena/models/EnvioFallido.dart';
import 'package:laboratorio_elena/networking/ApiBaseHelper.dart';

class EnvioInformadoRepository {

  // Class Atributes
  String baseUrl; 

  // Class Constructor
  EnvioInformadoRepository(
    {
      required this.baseUrl,
    }
  );

  late String _postBody;
  late ApiBaseHelper _helper = ApiBaseHelper(baseUrl: baseUrl);

  Future<int> informEnvio(int idEnvio, double geoLatitud, double geoLongitud, String observaciones, String token, BuildContext context) async {

    _postBody = jsonEncode(EnvioFallido(
      idEnvio: idEnvio,
      geoLatitud: geoLatitud,
      geoLongitud: geoLongitud,
      observaciones: observaciones
    ).toJson());
    
    final response = await _helper.post('/api/Envios/Informar', 'informEnvio', token, _postBody, context);
    return response;
  }
}