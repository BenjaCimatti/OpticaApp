import 'package:optica/models/version.dart';
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

  Future<Version> getVersion() async { // Gets Version from the API
    final response = await _helper.get('/api/Version/Get');
    return Version.fromJson(response);
  }
}