import "package:app/themes/transitions/custom_default_transition_builder.dart";
import "package:flutter/material.dart";

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
    primary: Color.fromARGB(255, 93, 100, 255),
    secondary: Color.fromARGB(255, 255, 255, 255),
    tertiary: Colors.grey,
    onTertiary: Color.fromARGB(255, 255, 255, 255), // there was no other appropriate name lol
    onSurface: Color.fromARGB(255, 134, 141, 255),
    error: Color.fromARGB(255, 224, 227, 255),

    background: Color.fromARGB(255, 250, 250, 250),
    onBackground: Color.fromARGB(255, 40, 40, 40),
  ),
  pageTransitionsTheme: const PageTransitionsTheme( //default transition
    builders: {
      TargetPlatform.android: CustomTransitionBuilder(),
      TargetPlatform.iOS: CustomTransitionBuilder(),
      TargetPlatform.macOS: CustomTransitionBuilder(),
      TargetPlatform.windows: CustomTransitionBuilder(),
      TargetPlatform.linux: CustomTransitionBuilder(),
    },
  ),
);
