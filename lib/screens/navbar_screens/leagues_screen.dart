import 'package:flutter/material.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
   @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // topBar(context,
        //  'lib/assets/images/Settings.svg',
        //  () {
        //   //TODO navigate to settings screen
        //  },
        // ),
        Expanded(
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
