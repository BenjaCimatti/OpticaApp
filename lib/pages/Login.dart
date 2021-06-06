import 'package:flutter/material.dart';
import 'package:optica/models/Token.dart';
import 'package:optica/models/Version.dart';
import 'package:optica/repository/TokenRepository.dart';
import 'package:optica/widgets/LoginTextField.dart';
import 'package:optica/widgets/VersionAlertDialog.dart';
import 'package:optica/repository/VersionRepository.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Future<Version> version;
  late Future<Token> token;
  
  static const String baseUrl = 'http://10.0.0.109:8089';

  static const String deviceVersion = '1.0.0';
  late String _latestVersion;
  bool _showCircularProgressIndicator = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    version = VersionRepository(baseUrl: baseUrl).getVersion(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.purple[50],
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/DiseñoLogin3.png'),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(width*0.06, height*0.1, 0, height*0.15),
                      child: Text(
                        'Inicio de Sesión',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                    LoginTextField(hintText: 'Usuario', obscureText: false, controller: _usernameController,),
                    LoginTextField(hintText: 'Contraseña', obscureText: true, controller: _passwordController,),
                    Padding(
                      padding: EdgeInsets.only(top: height*0.04),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () => setState(
                            () {
                              String username = _usernameController.text;
                              String password = _passwordController.text;

                              token = TokenRepository(baseUrl: baseUrl).getToken(username, password, context);
                            }
                          ),
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: width*0.2, vertical: height*0.028)),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.purple[800]!),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                          ),
                        ),
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



