import 'package:flutter/material.dart';

// cont Color primaryColor = Color.fromARGB(255, 93, 183, 172)
const Color primaryColor = Color.fromARGB(255, 93, 100, 255);
const Color secondaryColor = Color.fromARGB(255, 254, 255, 254);
const Color tertiaryColor = Color.fromARGB(255, 40, 40, 40);
const Color quaternaryColor = Color.fromARGB(255, 255, 255, 255);
const Color quinaryColor = Color.fromARGB(255, 0, 0, 0);
const Color senaryColor = Colors.grey;
const Color bgColor = Color.fromARGB(255, 250, 250, 250);
Color? navbarIconColor = Colors.grey[600];
Color? dialogWindowTextColor = Colors.grey[700];

// Colors for dark mode
const Color darkSecondaryColor = Color.fromARGB(255, 100, 100, 100);
const Color darkTertiaryColor = Color.fromARGB(255, 255, 255, 255);
const Color darkQuaternaryColor = Color.fromARGB(255, 0, 0, 0);
const Color darkQuinaryColor = Color.fromARGB(255, 255, 255, 255);
const Color darkBgColor = Color.fromARGB(255, 40, 40, 40);
Color? darkNavbarIconColor = Colors.grey[400];
Color? darkSenaryColor = Colors.grey[800];

Color getSecondaryColor(bool isDarkMode) {
  return isDarkMode ? darkSecondaryColor : secondaryColor;
}

Color getBgColor(bool isDarkMode) {
  return isDarkMode ? darkBgColor : bgColor;
}