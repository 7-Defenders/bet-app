import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget svgImageWithAction({
  required String svgPath,
  required double width,
  required double height,
  required Function() action,
}) {
  return GestureDetector(
    onTap: action,
    child: SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        svgPath,
      ),
    ),
  );
}
