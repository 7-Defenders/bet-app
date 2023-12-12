import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/models/structure.dart'; 
import 'package:app/components/leagues_screen/league_widget.dart';
import 'package:http/http.dart' as http;

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("hi"),
    );
  }
}

// tested league widget here because this screen was empty

// class _EventsScreenState extends State<EventsScreen> {
//   // Create a mock list of leagues for demonstration purposes.
//   final List<League> mockLeagues = [
//     League(id: '1', name: 'Szymon', svgPath: 'lib/assets/images/league_logos/premier_league.svg'),
//     League(id: '2', name: 'Dawid', svgPath: 'lib/assets/images/league_logos/premier_league.svg'),
//     League(id: '3', name: 'Matto', svgPath: 'lib/assets/images/league_logos/premier_league.svg'),
//     League(id: '4', name: 'SEMPUUU', svgPath: 'lib/assets/images/league_logos/premier_league.svg'),
//     League(id: '5', name: 'Herman', svgPath: 'lib/assets/images/league_logos/premier_league.svg'),
//     League(id: '6', name: 'Maciek', svgPath: 'lib/assets/images/league_logos/premier_league.svg'),
//   ];


//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         LeagueListWidget(
//           leagues: mockLeagues,
//           height: 300, 
//         ),
//       ],
//     );
//   }
// }

