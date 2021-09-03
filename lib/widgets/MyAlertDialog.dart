import 'package:flutter/material.dart';
import 'package:laboratorio_elena/classes/ColorPalette.dart';

class MyDialog {
  BuildContext context;
  String alertTitle;
  String alertContent;
  String buttonText;
  void Function()? buttonAction;

  MyDialog({
    required this.context,
    required this.alertTitle,
    required this.alertContent,
    required this.buttonText,
    this.buttonAction,
  });

  createDialog() async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
      return AlertDialog(
        title: Text(
          alertTitle,
          style: TextStyle(
            color: ColorPalette().getBluishGrey()
          ),
        ),
        content: Text(
          alertContent,
          style: TextStyle(
            color: ColorPalette().getLightBlueishGrey()
          ),
        ),
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        actions: <Widget>[
          MaterialButton(
            disabledTextColor: Colors.black.withOpacity(0.2),
            textColor: ColorPalette().getBluishGrey(),
            onPressed: buttonAction,
            child: Text(
              buttonText,
            ),
          )
        ],
      );
    });
  }
}