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
    return SafeArea(
      child: Column(
        children: [
          topBar(
            context,
            'lib/assets/images/Settings.svg',
            () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          // const BetSelector(),
        ],
      ),
    );
  }
}
