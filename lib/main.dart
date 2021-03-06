import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:laboratorio_elena/pages/Login.dart';
import 'package:laboratorio_elena/classes/ColorPalette.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorPalette().getDarkBlueishGrey(), // status bar color
  ));
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color:
          ColorPalette().getDarkBlueishGrey(),
      debugShowCheckedModeBanner: false,
      title: 'Laboratorio Elena',
      home: Login(),
    );
  }
}
