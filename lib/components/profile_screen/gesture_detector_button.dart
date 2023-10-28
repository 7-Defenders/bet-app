import 'package:app/components/constants.dart' as constants;
import 'package:app/components/nunito_text.dart';
import 'package:flutter/material.dart';

Widget gestureDetectorButton(
    IconData icon,
    String text,
    void Function()? onTap,
    double vw,
    double vh,
    bool isDarkMode,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 85*vw,
      height: 8*vh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: constants.getSecondaryColor(isDarkMode),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5*vw, 0, 5*vw, 0),
            child: Icon(icon, color: constants.primaryColor),
          ),
          nunitoText(text, 20, FontWeight.bold, constants.tertiaryColor),
        ],
      ),
    ),
  );
}
