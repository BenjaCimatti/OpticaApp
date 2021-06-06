import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class InvalidCredentials {

  createDialog(BuildContext context) async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
      return AlertDialog(
        title: Text(
          'Inicio de Sesión fallido',
          style: TextStyle(
            color: Colors.deepPurple[400]
          ),
        ),
        content: Text(
          'Usuario y/o Contraseña incorrectos',
          style: TextStyle(
            color: Colors.deepPurple[200]
          ),
        ),
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => Phoenix.rebirth(context),
            child: Text(
              'Ok',
              style: TextStyle(
                color: Colors.deepPurple[700]
              ),
            ),
          )
        ],
      );
    });
  }

  
}


        // showDialog(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (context) =>
        //   new AlertDialog(
        //     title: Text(
        //       'Nueva Versión Disponible',
        //       style: TextStyle(
        //         color: Colors.deepPurple[400]
        //       ),
        //     ),
        //     content: Text(
        //       'Su versión está obsoleta,\nconsulte con su proveedor',
        //       style: TextStyle(
        //         color: Colors.deepPurple[200]
        //       ),
        //     ),
        //     elevation: 10.0,
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            // actions: <Widget>[
            //   MaterialButton(
            //     onPressed: () => exit(0),
            //     child: Text(
            //       'Salir',
            //       style: TextStyle(
            //         color: Colors.deepPurple[700]
            //       ),
            //     ),
            //   )
            // ],
        //   ),
        // );