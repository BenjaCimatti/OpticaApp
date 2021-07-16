import 'package:flutter/material.dart';
import 'package:optica/classes/ColorPalette.dart';

// ignore: must_be_immutable
class DropdownMenu extends StatefulWidget {
  String holder = '';
  String dropdownValue = 'No estaba';

  String getDropdownValue() {
    return dropdownValue;
  }

  @override
  State<DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.dropdownValue,
      iconSize: 18,
      elevation: 6,
      isExpanded: true,
      style: TextStyle(color: ColorPalette().getBluishGrey()),
      underline: Container(
        height: 2,
        color: ColorPalette().getDarkBlueishGrey(),
      ),
      onChanged: (String? newValue) {
        setState(() {
          widget.dropdownValue = newValue!;
        });
      },
      items: <String>['No estaba', 'Mala dirección', 'Caso de ejemplo 3', 'Caso de ejemplo 4']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
