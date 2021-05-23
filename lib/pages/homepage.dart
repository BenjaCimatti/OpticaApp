import 'package:flutter/material.dart';
import 'package:optica/models/version.dart';
import 'package:optica/services/api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Version> version;
  static const String apiUrl = 'http://10.0.0.107:8089';

  @override
  void initState() {
    version = ApiHandler(apiUrl: apiUrl).getVersion();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: Text('Prueba API'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: FutureBuilder<Version>(
          future: version,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.version);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator(
              color: Colors.deepPurple,
            );
          },
        ),
      ),
    );
  }
}