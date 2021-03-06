
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laboratorio_elena/models/Envio.dart';
import 'package:laboratorio_elena/networking/ApiBaseHelper.dart';

class EnvioRepository {

  // Class Atributes
  String baseUrl; 

  // Class Constructor
  EnvioRepository(
    {
      required this.baseUrl,
    }
  );

  late ApiBaseHelper _helper = ApiBaseHelper(baseUrl: baseUrl);

  Future<List<Envio>> enviosFromJson(String str) async => List<Envio>.from(json.decode(str).map((x) => Envio.fromJson(x)));


  Future<List<Envio>> getEnvio(String token, BuildContext context) async {
    
    final response = await _helper.get('/api/Envios/Get', token, 'envios', context);
    final envios = enviosFromJson(jsonEncode(response));
    return envios;
  }
}