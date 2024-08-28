import "package:app/themes/transitions/custom_default_transition_builder.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    // only return the child without warping it with animations
    return child!;
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 255, 163, 16),
    secondary: Color.fromARGB(255, 255, 186, 75),
    tertiary: Color.fromARGB(255, 96, 179, 255),
    onTertiary: Color.fromARGB(
        255, 255, 255, 255,), // there was no other appropriate name lol
    error: Color.fromARGB(255, 224, 227, 255),

    surface: Color.fromARGB(255, 250, 250, 250),
    onSurface: Color.fromARGB(255, 30, 30, 27),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    //default transition
    builders: {
      TargetPlatform.android: CustomTransitionBuilder(),
      TargetPlatform.iOS: CustomTransitionBuilder(),
      TargetPlatform.macOS: CustomTransitionBuilder(),
      TargetPlatform.windows: CustomTransitionBuilder(),
      TargetPlatform.linux: CustomTransitionBuilder(),
    },
  ),
  textTheme: TextTheme(
    displayMedium: GoogleFonts.nunito(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(255, 30, 30, 27),
    ),
    displaySmall: GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(255, 30, 30, 27),
    ),
  ),
  iconTheme: const IconThemeData(
    size: 26,
    color: Color.fromARGB(255, 30, 30, 27),
  ),
);
