import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:optica/classes/ColorPalette.dart';
import 'package:optica/classes/Encode.dart';
import 'package:optica/models/Token.dart';
import 'package:optica/models/Version.dart';
import 'package:optica/pages/ListaEnvios.dart';
import 'package:optica/repository/TokenRepository.dart';
import 'package:optica/widgets/LoginShapes.dart';
import 'package:optica/widgets/LoginTextField.dart';
import 'package:optica/widgets/MyDialog.dart';
import 'package:optica/repository/VersionRepository.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Future<Version> version;
  late Future<Token> token;

  static const String baseUrl = 'http://10.0.0.5:8089';

  static const String deviceVersion = '1.0.0';
  late String _latestVersion;

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
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {

                                String username = _usernameController.text;
                                String rawPassword = _passwordController.text;

                                String password = Encode().hash256(rawPassword);

                                token = TokenRepository(baseUrl: baseUrl)
                                    .getToken(username, password, context);

                                token.then((value) {
                                  if (value.idRol == 2) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ListaEnvios(token: value.token, username: value.usuario, baseUrl: baseUrl,)
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
