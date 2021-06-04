import 'package:flutter/material.dart';
import 'package:optica/models/version.dart';
import 'package:optica/models/widgets/VersionAlertDialog.dart';
import 'package:optica/repository/VersionRepository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Version> version;
  static const String baseUrl = 'http://10.0.0.109:8089';

  static const String deviceVersion = '2.0.0';
  late String _latestVersion;
  bool _showCircularProgressIndicator = true;



  @override
  void initState() {
    super.initState();
    version = VersionRepository(baseUrl: baseUrl).getVersion();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => print('hola'),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          color: Colors.deepPurple[50],
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: FutureBuilder<Version>(
                    future: version,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //return Text(snapshot.data!.version);
                        _latestVersion = snapshot.data!.version;
                        if (deviceVersion != _latestVersion) {
                          VersionAlertDialog().createDialog(context);
                        } else {
                          _showCircularProgressIndicator = false;
                        }

                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      if (_showCircularProgressIndicator) {
                        return CircularProgressIndicator(
                          valueColor: 
                            AlwaysStoppedAnimation<Color>
                              (Colors.deepPurple)
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



