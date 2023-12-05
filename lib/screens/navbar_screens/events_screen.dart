import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {

  @override
  Widget build(BuildContext context) {

    Future<void> callFunctionPrintResultToConsole() async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final String uid = auth.currentUser!.uid;
      final response = await http.post(
        Uri.parse("https://joinleague-vhn3gxevdq-ew.a.run.app"),
        body: {
          'uid': uid,
          'leagueId': 'ImIlLZv9iXdWQFSpK8YB',
        },
      );
    }

    return Column(
      children: [
        Expanded(
          child: Center(
            child: ElevatedButton(
              onPressed: callFunctionPrintResultToConsole,
              child: const Text("join league"),
            )
          ),
        ),
      ],
    );
  }
}
