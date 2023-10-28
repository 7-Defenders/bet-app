import 'package:app/utils/constants.dart' as constants;
import 'package:flutter/material.dart';

// profile picture with border
Widget pictureWithBorder (
  String? photoURL,
  double vh,
) {
  return Container(
    width: 19*vh,
    height: 19*vh,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40),
      border: Border.all(width: 10, color: constants.secondaryColor),
      image: DecorationImage(
        fit: BoxFit.fill,
        image: photoURL != ""
            ? Image.network(photoURL!).image
            : Image.asset('lib/assets/images/default_profile_picture.png').image,
      ),
    ),
  );
}

// editing profile picture button
Widget smallButton(
    void Function()? onTap,
    double vw,
    double vh,
    IconData? icon,
) {
  return Center(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 6*vh,
        height: 5.5*vh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: constants.secondaryColor,
        ),
        child: Icon(
          icon,
          color: constants.primaryColor,
        ),
      ),
    ),
  );
}
