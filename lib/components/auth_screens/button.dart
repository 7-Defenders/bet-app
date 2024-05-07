import 'package:app/components/other/nunito_text.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool isClickable;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.isClickable,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 163, 16),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: nunitoText(
            text,
            18,
            FontWeight.normal,
            Color.fromARGB(255, 30, 30, 27),
          ),
        ),
      ),
    );
  }
}
