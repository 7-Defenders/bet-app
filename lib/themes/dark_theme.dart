import "package:flutter/material.dart";

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 93, 100, 255),
    secondary: const Color.fromARGB(255, 70, 70, 70),
    tertiary: Colors.grey[800],
    onTertiary: const Color.fromARGB(255, 35, 35, 35),
    onSurface: const Color.fromARGB(255, 134, 141, 255),
    error: const Color.fromARGB(255, 224, 227, 255),

    surface: const Color.fromARGB(255, 40, 40, 40),
    // onSurface: const Color.fromARGB(255, 208, 208, 208),
  ),
);
