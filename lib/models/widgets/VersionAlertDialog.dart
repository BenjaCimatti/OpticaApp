import 'dart:io';
import 'package:flutter/material.dart';

class VersionAlertDialog {

  createDialog(BuildContext context) async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
      return AlertDialog(
        title: Text(
          'Nueva Versión Disponible',
          style: TextStyle(
            color: Colors.deepPurple[400]
          ),
        ),
        content: Text(
          'Su versión está obsoleta,\nconsulte con su proveedor',
          style: TextStyle(
            color: Colors.deepPurple[200]
          ),
        ),
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => exit(0),
            child: Text(
              'Salir',
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