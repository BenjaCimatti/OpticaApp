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
  bool isButtonDisabled;

  MyConfirmationDialog({
    required this.context,
    required this.alertTitle,
    required this.alertContent,
    required this.buttonText1,
    required this.buttonText2,
    required this.buttonAction1,
    required this.buttonAction2,
    required this.isButtonDisabled,
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
            disabledTextColor: Colors.black.withOpacity(0.2),
            textColor: ColorPalette().getBluishGrey(),
            onPressed: isButtonDisabled ? null : buttonAction1,
            child: Text(
              buttonText1,
            ),
          ),
          MaterialButton(
            disabledTextColor: Colors.black.withOpacity(0.2),
            textColor: ColorPalette().getBluishGrey(),
            onPressed: isButtonDisabled ? null : buttonAction2,
            child: Text(
              buttonText2,
            ),
          )
        ],
      );
    });
  }
}