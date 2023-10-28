import "package:flutter/material.dart";

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 93, 100, 255),
    secondary: Color.fromARGB(255, 255, 255, 255),
    tertiary: Colors.grey,
    onTertiary: Color.fromARGB(255, 255, 255, 255), // there was no other appropriate name lol

    background: Color.fromARGB(255, 250, 250, 250),
    onBackground: Color.fromARGB(255, 40, 40, 40),
  ),
);
