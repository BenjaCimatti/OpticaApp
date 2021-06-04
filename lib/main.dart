import 'package:flutter/material.dart';
import 'package:optica/pages/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.deepPurple,
      debugShowCheckedModeBanner: false,
      title: 'Envíos',
      home: HomePage(),
    );
  }
}