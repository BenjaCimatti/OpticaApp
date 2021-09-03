import 'package:flutter/material.dart';
import 'package:laboratorio_elena/classes/ColorPalette.dart';

class TrailingIcon extends StatelessWidget {
  TrailingIcon({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            
            decoration: BoxDecoration(
              color: ColorPalette().getBluishGrey(),
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorPalette().getLightGreen(),
                width: 2

              )
            ),
            child: Icon(Icons.check_circle_rounded, color: color,),
          )
        ],
      ),
    );
  }
}