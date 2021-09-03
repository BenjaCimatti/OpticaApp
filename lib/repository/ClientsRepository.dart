import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laboratorio_elena/models/Client.dart';
import 'package:laboratorio_elena/networking/ApiBaseHelper.dart';

class ClientsRepository {

  // Class Atributes
  String baseUrl; 

  // Class Constructor
  ClientsRepository(
    {
      required this.baseUrl,
    }
  );

  late ApiBaseHelper _helper = ApiBaseHelper(baseUrl: baseUrl);

  Future<List<Client>> clientsFromJson(String str) async => List<Client>.from(json.decode(str).map((x) => Client.fromJson(x)));

  Future<List<Client>> getClients(String token, BuildContext context) async {
    
    final response = await _helper.get('/api/Clientes/Get', token, 'getClients', context);
    final clients = clientsFromJson(jsonEncode(response));
    return clients;
  }
}