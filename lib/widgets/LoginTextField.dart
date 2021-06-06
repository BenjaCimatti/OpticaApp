import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoginTextField extends StatefulWidget {
  
  static const double pi = math.pi;

  final String hintText;

  final bool obscureText;

  final TextEditingController controller; 

  LoginTextField({ 
    Key? key, 
    required this.hintText,
    required this.obscureText,
    required this.controller,
  }) : super(key: key);

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return Container(
      margin: EdgeInsets.fromLTRB(width*0.07, 0, width*0.07, height*0.015),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextField(
        obscureText: widget.obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: <BoxShadow>[
          BoxShadow(
            spreadRadius: -8,
            blurRadius: 8,
            offset: Offset.fromDirection(LoginTextField.pi/2, 3)
          ),
        ],
      ),
    );
  }
}
                 
                    


