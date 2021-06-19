import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:optica/classes/ColorPalette.dart';

class NoData extends StatelessWidget {
  const NoData({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/NoData.svg',
              placeholderBuilder: (context) {
                return Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(ColorPalette().getLightGreen()),
                    ),
                  );
              }
            ),
            SizedBox(
              height: height * 0.1,
            )
          ],
        ),
      ),
    );
  }
}