import 'package:app/components/other/nunito_text.dart';
import 'package:flutter/material.dart';

class GamemodeCard extends StatelessWidget {

  final String title;
  final Widget child;
  final Function() onTap;

  const GamemodeCard({required this.title, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              nunitoText(title, 20, FontWeight.bold, Colors.black),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
