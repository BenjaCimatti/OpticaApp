import 'package:flutter/material.dart';
import 'package:laboratorio_elena/classes/ColorPalette.dart';

class LoginTextField extends StatefulWidget {

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
      margin: EdgeInsets.fromLTRB(width*0.0864, 0, width*0.0864, height*0.0205),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextField(
        cursorColor: ColorPalette().getLightGreen(),
        obscureText: widget.obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black.withOpacity(0.25)
          ),
          border: InputBorder.none,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
                 
                    


