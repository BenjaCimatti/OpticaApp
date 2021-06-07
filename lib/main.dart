import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:optica/pages/Login.dart';
import 'package:optica/classes/ColorPalette.dart';


void main() {
  runApp(
    Phoenix(
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: ColorPalette().getBluishGrey(),// Have to find a darker one...
      debugShowCheckedModeBanner: false,
      title: 'Envíos',
      home: Login(),
    );
  }
}