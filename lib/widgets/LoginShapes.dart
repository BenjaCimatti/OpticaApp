import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginShapes extends StatelessWidget {
  const LoginShapes({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/svg/TopLeftTriangleShape.svg',
            width: width*1,
            height: height*1,
          ),
          SvgPicture.asset(
            'assets/svg/TopRightTriangleShape.svg',
            width: width*1,
            height: height*1,
          ),
          SvgPicture.asset(
            'assets/svg/SquareShape.svg',
            width: width*1,
            height: height*1,
          ),
          SvgPicture.asset(
            'assets/svg/CircleShape.svg',
            width: width*1,
            height: height*1,
          ),
          SvgPicture.asset(
            'assets/svg/BottomRightTriangleShape.svg',
            width: width*1,
            height: height*1,
          ),
        ],
      ),
    );
  }
}