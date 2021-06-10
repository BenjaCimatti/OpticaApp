import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginShapes extends StatelessWidget {
  const LoginShapes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        child: SvgPicture.asset(
      'assets/svg/Shapes.svg',
      width: width * 1,
      fit: BoxFit.fitWidth,
    ));
  }
}
