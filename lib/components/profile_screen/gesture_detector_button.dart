import 'package:app/components/other/nunito_text.dart';
import 'package:flutter/material.dart';

Widget gestureDetectorButton(
  IconData icon,
  String text,
  void Function()? onTap,
  double vw,
  double vh,
  BuildContext context,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 85 * vw,
      height: 8 * vh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5 * vw, 0, 5 * vw, 0),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          nunitoText(text, 20, FontWeight.bold,
              Theme.of(context).colorScheme.onSurface,),
        ],
      ),
    ),
  );
}
