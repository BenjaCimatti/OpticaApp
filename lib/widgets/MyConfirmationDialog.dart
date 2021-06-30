import 'package:flutter/material.dart';
import 'package:optica/classes/ColorPalette.dart';

class MyConfirmationDialog {
  BuildContext context;
  String alertTitle;
  String alertContent;
  String buttonText1;
  String buttonText2;
  void Function() buttonAction1;
  void Function() buttonAction2;

  MyConfirmationDialog({
    required this.context,
    required this.alertTitle,
    required this.alertContent,
    required this.buttonText1,
    required this.buttonText2,
    required this.buttonAction1,
    required this.buttonAction2,
  });

  createDialog() async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
      return AlertDialog(
        scrollable: true,
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
            onPressed: buttonAction1,
            child: Text(
              buttonText1,
              style: TextStyle(
                color: ColorPalette().getBluishGrey()
              ),
            ),
          ),
          MaterialButton(
            onPressed: buttonAction2,
            child: Text(
              buttonText2,
              style: TextStyle(
                color: ColorPalette().getBluishGrey()
              ),
            ),
          )
        ],
      );
    });
  }
}