import 'package:flutter/material.dart';

Widget imageWithAction({
  required String path,
  required double width,
  required double height,
  required Function() action,
}) {
  return GestureDetector(
    onTap: action,
    child: SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        path,
      ),
    ),
  );
}
