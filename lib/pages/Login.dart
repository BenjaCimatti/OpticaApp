import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:geolocator/geolocator.dart';
import 'package:laboratorio_elena/classes/ColorPalette.dart';
import 'package:laboratorio_elena/classes/Encode.dart';
import 'package:laboratorio_elena/classes/Location.dart';
import 'package:laboratorio_elena/models/Token.dart';
import 'package:laboratorio_elena/models/Version.dart';
import 'package:laboratorio_elena/pages/ListaEnvios.dart';
import 'package:laboratorio_elena/repository/TokenRepository.dart';
import 'package:laboratorio_elena/widgets/LoginShapes.dart';
import 'package:laboratorio_elena/widgets/LoginTextField.dart';
import 'package:laboratorio_elena/widgets/MyAlertDialog.dart';
import 'package:laboratorio_elena/repository/VersionRepository.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Future<Version> version;
  late Future<Token> token;
  late Future<Position> position;

  static const String baseUrl = 'http://179.42.160.161:8081'; //200.117.48.200:8081 //10.0.0.4:8081

  static const String deviceVersion = '1.0.0';
  late String _latestVersion;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    version = VersionRepository(baseUrl: baseUrl).getVersion('ApiLogistica', context);
    position = determinePosition(context);
    position.then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorPalette().getBluishGrey(),
        body: Stack(
          children: [
            LoginShapes(),
            SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              0, height * 0.0753, 0, height * 0.05),
                          child: SvgPicture.asset(
                            'assets/svg/Logo.svg',
                            width: width * 0.4,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.0864, 0, 0, height * 0.0179),
                        child: Text(
                          'Inicio de\nSesión',
                          style: TextStyle(
                            height: 1.3,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: height * 0.0513,
                          ),
                        ),
                      ),
                      LoginTextField(
                        hintText: 'Usuario',
                        obscureText: false,
                        controller: _usernameController,
                      ),
                      LoginTextField(
                        hintText: 'Contraseña',
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.02),
                        child: Center(
                          child: !isLoading ? ElevatedButton(
                            onPressed: () {
                              setState(() {

                                String username = _usernameController.text;
                                String rawPassword = _passwordController.text;

                                String password = Encode().hash256(rawPassword);

                                token = TokenRepository(baseUrl: baseUrl)
                                    .getToken(username, password, 1, context);

                                token.then((value) {
                                  if (value.idRol == 2) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ListaEnvios(token: value.token, username: value.usuario, descUsuario: value.descUsuario, baseUrl: baseUrl,)
                                    ));
                                  } else {
                                    MyDialog(
                                        context: context,
                                        alertTitle: 'Inicio de sesión fallido',
                                        alertContent:
                                            'Esta cuenta no pertenece\na un transportista',
                                        buttonText: 'Ok',
                                        buttonAction: () => Phoenix.rebirth(
                                            context)).createDialog();
                                  }
                                });
                                isLoading = !isLoading;
                              });
                            },
                            child: Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(0),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(
                                    horizontal: width * 0.15,
                                    vertical: height * 0.028),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                ColorPalette().getLightGreen(),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          )
                          : Center(child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorPalette().getLightGreen()),)) 
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: FutureBuilder<Version>(
                      future: version,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _latestVersion = snapshot.data!.version;
                          if (deviceVersion != _latestVersion) {
                            MyDialog(
                                context: context,
                                alertTitle: 'Nueva Versión Disponible',
                                alertContent:
                                    'Su versión está obsoleta,\nconsulte con su proveedor',
                                buttonText: 'Salir',
                                buttonAction: () => exit(0)).createDialog();
                          }
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
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
      ),
    );
  }
}
