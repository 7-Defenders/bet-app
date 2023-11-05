import 'package:flutter/material.dart';

Widget nickButton(
    void Function()? onTap,
    double vw,
    double vh,
    IconData? icon,
    BuildContext context,
    ) {
  return Center(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 6*vh,
        height: 5.5*vh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    ),
  );
}
