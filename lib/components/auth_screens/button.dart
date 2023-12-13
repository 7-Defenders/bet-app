import 'package:app/components/other/nunito_text.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final Function()? onTap;
  final String text;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: nunitoText(
            text,
            18,
            FontWeight.normal,
            Theme.of(context).colorScheme.background,
          ),
        ),),
    );
  }
}
