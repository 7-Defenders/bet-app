import 'package:app/components/top_bar.dart';
import 'package:flutter/material.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
   @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topBar(context),
        const Expanded(
          child: Center(
              child: Text(
                'Leagues go here',
                style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
                ),
          ),
        ),
      ],
    );
  }
}
