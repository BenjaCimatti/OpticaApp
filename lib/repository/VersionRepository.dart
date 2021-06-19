import 'package:flutter/material.dart';
import 'package:optica/models/Version.dart';
import 'package:optica/networking/ApiBaseHelper.dart';

class VersionRepository {

  // Class Atributes
  String baseUrl; 

  // Class Constructor
  VersionRepository(
    {
      required this.baseUrl,
    }
  );


  late ApiBaseHelper _helper = ApiBaseHelper(baseUrl: baseUrl);

  Future<Version> getVersion(String component, BuildContext context) async { // Gets Version from the API

    final response = await _helper.get('/api/Version/Get?Componente=$component', null, null, context);
    return Version.fromJson(response);
  }
}