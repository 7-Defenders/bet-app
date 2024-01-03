import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page<dynamic> Function(BuildContext, GoRouterState)? fadePageBuilder (
    Widget screen,
  ){
  return (BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: screen,
      transitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder:
      (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  };
}
