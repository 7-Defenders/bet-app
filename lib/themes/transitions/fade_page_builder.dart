import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// for other pages than profile, just pass (context, state, _)=> PageName() and null.
Page<dynamic> Function(BuildContext, GoRouterState)? fadePageBuilder(
  Widget Function(BuildContext context, GoRouterState state, String? uid)
      screenBuilder,
  String? uid,
) {
  return (BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: screenBuilder(context, state, uid),
      transitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  };
}
