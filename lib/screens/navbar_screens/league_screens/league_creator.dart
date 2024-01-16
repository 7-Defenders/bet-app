import 'dart:convert';

import 'package:app/components/other/nunito_text.dart';
import 'package:app/models/structure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LeagueCreator extends StatefulWidget {
  const LeagueCreator({super.key});

  @override
  State<LeagueCreator> createState() => _LeagueCreatorState();
}

class _LeagueCreatorState extends State<LeagueCreator> {

  Set<String> selectedLeagues = {};
  int entryCost = 0;
  String leagueName = '';

  final entryCostController = TextEditingController();
  final leagueNameController = TextEditingController();
  
  final List<bool> _selected = [true, false, false];

  @override
  void dispose() {
    entryCostController.dispose();
    leagueNameController.dispose();
    super.dispose();
  }

  void setSelected(int index){
    if (_selected[index] == true) return;

    switch(index){
      case 0:
        _selected[0] = true;
        _selected[1] = false;
        _selected[2] = false;

      case 1:
        _selected[1] = true;
        _selected[0] = false;
        _selected[2] = false;

      case 2:
        _selected[2] = true;
        _selected[0] = false;
        _selected[1] = false;
    }
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
        title: nunitoText(sportsObject[index].name, 18, FontWeight.bold, Colors.black),
        children: sportsObject[index].countries.map((country) {
          return ExpansionTile(
            title: nunitoText(country.name, 16, FontWeight.w700, Colors.black),
            children: country.leagues.map((league) {
              final path = '${sportsObject[index].name}/${country.name}/${league.name}';
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CheckboxListTile(
                    title: nunitoText(league.name, 14, FontWeight.normal, Colors.black),
                    value: selectedLeagues.contains(path),
                    onChanged: (val) {
                      setState(() {
                        if (selectedLeagues.contains(path)) {
                          selectedLeagues.remove(path);
                        } else {
                          selectedLeagues.add(path);
                        }
                      });
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

  Widget getTabWidget(String title, double padding, bool isTabSelected, Color backgroundColor){
    return isTabSelected
    ? Center(child: nunitoText(title, 16, FontWeight.bold, Colors.white))
    : Container(width: double.infinity, height: double.infinity, color: backgroundColor, child: Center(child: nunitoText(title, 16, FontWeight.bold, Colors.white)));
  }

  @override
  Widget build(BuildContext context) {

    const textFieldColor = Color.fromARGB(255, 230, 230, 230);
    final textFieldWidth = MediaQuery.of(context).size.width * 0.9;
    const borderStyle = OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(color: textFieldColor),
                        );
    const toggleButtonBorderRadius = BorderRadius.all(Radius.circular(20));

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
      body: Column(
          children: [
            ToggleButtons(
              onPressed: (int index) {
                setState(() {
                  setSelected(index);
                });
              },
              borderRadius: toggleButtonBorderRadius,
              fillColor: const Color.fromARGB(255, 96, 179, 255),
              constraints: BoxConstraints.expand(width: textFieldWidth / 3, height: 40),
              isSelected: _selected,
              children: [
                getTabWidget("Friend", 5, _selected[0], const Color.fromARGB(255, 255, 186, 75)),
                getTabWidget("Private", 5, _selected[1], const Color.fromARGB(255, 255, 186, 75)),
                getTabWidget("Public", 5, _selected[2], const Color.fromARGB(255, 255, 186, 75)),
              ],
            ),
            const Center(child: Text('League name')),
            Center(
              child: SizedBox(
                width: textFieldWidth,
                child: TextField(
                  controller: leagueNameController,
                  decoration: const InputDecoration(
                    enabledBorder: borderStyle,
                    focusedBorder: borderStyle,
                    filled: true,
                    fillColor: textFieldColor,
                    hintText: 'League name',
                  ),
                ),
              ),
            ),
            const Center(child: Text('Entry fee')),
            Center(
              child: SizedBox(
                width: textFieldWidth,
                child: TextField(
                  controller: entryCostController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    enabledBorder: borderStyle,
                    focusedBorder: borderStyle,
                    filled: true,
                    fillColor: textFieldColor,
                    hintText: 'Entry fee',
                  ),
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
    );
  }
}
