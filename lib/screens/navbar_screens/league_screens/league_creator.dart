import 'dart:convert';

import 'package:app/models/structure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LeagueCreator extends StatefulWidget {
  const LeagueCreator({Key? key});

  @override
  State<LeagueCreator> createState() => _LeagueCreatorState();
}

class _LeagueCreatorState extends State<LeagueCreator> {

  Set<String> selectedLeagues = {};
  int entryCost = 0;
  String leagueName = '';

  final entryCostController = TextEditingController();
  final leagueNameController = TextEditingController();

  @override
  void dispose() {
    entryCostController.dispose();
    leagueNameController.dispose();
    super.dispose();
  }

  Future<void> createLeague() async{
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.primary, size: 55,),
        );
      },
    );

    if (leagueNameController.text == '' || int.parse(entryCostController.text) < 0 || selectedLeagues.isEmpty) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final List<String> competitions = [];
    for (final element in selectedLeagues) { 
      competitions.add(
        sportsObject.firstWhere((sport) => sport.name == element.split('/')[0]).countries
                  .firstWhere((country) => country.name == element.split('/')[1]).leagues
                  .firstWhere((league) => league.name == element.split('/')[2]).id,
      );
    }

    final response = await http.post(
      Uri.parse('https://bet-app-e520a.ew.r.appspot.com/v1/leagues'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userID': uid,
        'entryCost': int.parse(entryCostController.text),
        'leagueName': leagueNameController.text,
        'competitionRefs': competitions,
        'private': true,
      }),
    );

    if (mounted){
      Navigator.of(context).pop();
    }
  }

  Widget setupAlertDialoadContainer() {
  return SizedBox(
    height: 300.0, // Change as per your requirement
    width: 300.0, // Change as per your requirement
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: sportsObject.length,
      itemBuilder: (BuildContext context, int index) {
      return ExpansionTile(
        title: Text(sportsObject[index].name),
        children: sportsObject[index].countries.map((country) {
          return ExpansionTile(
            title: Text(country.name),
            children: country.leagues.map((league) {
              final path = '${sportsObject[index].name}/${country.name}/${league.name}';

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CheckboxListTile(
                    title: Text(league.name),
                    value: selectedLeagues.contains(path),
                    onChanged: (val) {
                      setState(() {
                        if (selectedLeagues.contains(path)) {
                          selectedLeagues.remove(path);
                        } else {
                          selectedLeagues.add(path);
                        }
                      });
                      print(selectedLeagues.toList());
                    },
                    selected: selectedLeagues.contains(path),
                  );
                },
              );
            }).toList(),
          );
        }).toList(),
      );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('League Creator'),
      ),
      body: ColoredBox(
        color: Colors.white,
        child: Column(
          children: [
            const Center(child: Text('League name')),
            Center(child: TextField(
              controller: leagueNameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'League name',
                ),
              ),
            ),
            const Center(child: Text('Entry fee')),
            Center(child: TextField(
              controller: entryCostController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entry fee',
                ),
              ),
            ),
            const Center(child: Text('Competitions included')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 5, 160, 221),
              ),
              onPressed: () async {
                  await showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                      content: setupAlertDialoadContainer(),
                    ),
                  );
              },
              child: const Text(
                'Pick competitions',
                style: TextStyle(color: Colors.white),
                ),
             ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 5, 160, 221),
              ),
              onPressed: () async {
                await createLeague();
              },
              child: const Text(
                'Create league',
                style: TextStyle(color: Colors.white),
                ),
             ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
