import 'package:app/components/bet_preview.dart';
import 'package:app/components/bet_selector.dart';
import 'package:app/components/top_bar.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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
              'Events go here',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const BetSelector(),
          const BetPreviewWidget(eventName: 'Arsenal - Chelsea', eventDetails: 'Premier League', bets: {'1':1.91, '1X':1.37, 'X': 3.24, 'X2':1.73, '2':2.06},),
        ],
      ),
    );
  }
}
