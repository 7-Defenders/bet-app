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
    return Column(
      children: [
        topBar(context),
        const Expanded(
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
        ),
      ],
    );
  }
}
