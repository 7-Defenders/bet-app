import 'dart:convert';
import 'dart:math';

import 'package:app/components/other/nunito_text.dart';
import 'package:app/globals.dart';
import 'package:app/models/structure.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class DuelCreator extends StatefulWidget {
  const DuelCreator({super.key});

  @override
  State<DuelCreator> createState() => _DuelCreatorState();
}

class _DuelCreatorState extends State<DuelCreator> {
  Set<String> selectedLeagues = {};
  int entryCost = 0;
  int gameCount = 5;
  String inviteeCode = '';

  final entryCostController = TextEditingController();
  final inviteeCodeController = TextEditingController();
  final gameCountController = TextEditingController();

  final List<bool> _selected = [true, false, false];

  @override
  void dispose() {
    entryCostController.dispose();
    super.dispose();
  }

  void setSelected(int index) {
    if (_selected[index] == true) return;

    switch (index) {
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

  Future<void> createDuel() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: Theme.of(context).colorScheme.primary,
            size: 55,
          ),
        );
      },
    );

    if (inviteeCodeController.text.length != 6) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: resultPopup("Invalid invite code",
            subtext: "Invite code must be exactly 6 characters long",),
        ),
      );

      return;
    }

    if (selectedLeagues.isEmpty) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: resultPopup("No selected competitions",
              subtext: "You have selected no competitions",),
        ),
      );
      return;
    }

    try {
      gameCount = int.parse(gameCountController.text);
      if (gameCount < 1) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            content: resultPopup("Invalid game count",
                subtext: "Game count cannot be lower than 1",),
          ),
        );
        return;
      }

      final minEntryCost = min(gameCount, 10);

      if (int.parse(entryCostController.text) < minEntryCost) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            content: resultPopup("Invalid stake",
                subtext: "Wager cannot be lower than $minEntryCost",),
          ),
        );
        return;
      }
    } on Exception catch (_) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: resultPopup("Invalid entry fee",
              subtext: "Entry fee has to be an integer value",),
        ),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final List<String> competitions = [];
    for (final element in selectedLeagues) {
      competitions.add(
        sportsObject
            .firstWhere((sport) => sport.name == element.split('/')[0])
            .countries
            .firstWhere((country) => country.name == element.split('/')[1])
            .leagues
            .firstWhere((league) => league.name == element.split('/')[2])
            .id,
      );
    }

    final body = jsonEncode(<String, dynamic>{
      'hostID': uid,
      'inviteeCode': inviteeCodeController.text,
      'entryCost': int.parse(entryCostController.text),
      'competitionRefs': competitions,
      'type': _selected[0] ? null : _selected[1],
    });

    debugPrint(body);
    return;
    final response = await http.post(
      Uri.parse('https://flask-vhn3gxevdq-ew.a.run.app/v1/leagues'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    debugPrint("${response.statusCode}, ${response.body}");

    switch (response.statusCode ~/ 100) {
      case 4:
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            content: resultPopup("Bad request", subtext: "Incorrect data"),
          ),
        );
      case 5:
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            content: resultPopup("Server error",
                subtext: "There was an error on our side. Sorry!",),
          ),
        );
      case 2:
        {
          // Globals.joinedNewDuel = true;
          Provider.of<UserDataProvider>(context, listen: false).userData?.leaguesJoined++; 
          if (mounted) {
            Navigator.of(context).pop(true);
          }
          Navigator.of(context, rootNavigator: true).pop(true);     
        }
    }
  }

  Widget resultPopup(String text,
      {String? subtext, double height = 120.0, double width = 300.0,}) {
    final closePopupButton = ElevatedButton(
      onPressed: () {
        setState(() {});
        Navigator.of(context, rootNavigator: true).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: nunitoText('Close', 14, FontWeight.bold, Colors.white),
    );

    final childWidget = subtext == null
        ? Column(
            children: [
              nunitoText(text, 18, FontWeight.bold, Colors.black),
              const Spacer(),
              closePopupButton,
            ],
          )
        : Column(
            children: [
              nunitoText(text, 18, FontWeight.bold, Colors.black),
              nunitoText(subtext, 14, FontWeight.normal, Colors.black),
              const Spacer(),
              closePopupButton,
            ],
          );

    return SizedBox(
      height: height,
      width: width,
      child: childWidget,
    );
  }

  Widget leaguePickerPopup({double height = 300.0, double width = 300.0}) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        children: [
          SizedBox(
            height: 240.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sportsObject.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  shape: const Border(),
                  title: nunitoText(sportsObject[index].name, 18,
                      FontWeight.bold, Colors.black,),
                  children: sportsObject[index].countries.map((country) {
                    return ExpansionTile(
                      shape: const Border(),
                      title: nunitoText(
                          country.name, 16, FontWeight.w700, Colors.black,),
                      children: country.leagues.map((league) {
                        final path =
                            '${sportsObject[index].name}/${country.name}/${league.name}';
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return CheckboxListTile(
                              title: nunitoText(league.name, 14,
                                  FontWeight.normal, Colors.black,),
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
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: nunitoText('Close', 14, FontWeight.bold, Colors.white),
          ),
        ],
      ),
    );
  }

  Widget getTabWidget(
      String title, double padding, bool isTabSelected, Color backgroundColor,) {
    return isTabSelected
        ? Center(child: nunitoText(title, 16, FontWeight.bold, Colors.white))
        : Container(
            width: double.infinity,
            height: double.infinity,
            color: backgroundColor,
            child: Center(
                child: nunitoText(title, 16, FontWeight.bold, Colors.white),),);
  }

  @override
  Widget build(BuildContext context) {
    const textFieldColor = Color.fromARGB(255, 230, 230, 230);
    final textFieldWidth = MediaQuery.of(context).size.width * 0.9;
    final buttonWidth = MediaQuery.of(context).size.width * 0.7;
    const borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      borderSide: BorderSide(color: textFieldColor),
    );
    const toggleButtonBorderRadius = BorderRadius.all(Radius.circular(20));
    const buttonBorderRadius15 = BorderRadius.all(Radius.circular(15));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: nunitoText('Duel Creator', 24, FontWeight.bold, Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: textFieldWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      nunitoText("Duel type", 18, FontWeight.normal, Colors.black,),
                      IconButton(
                        icon: const Icon(Icons.help_outline),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: nunitoText(
                                "Weighted duels mean you place standard bets with predeclared amount of coins to split among the games.\n\n"+
                                "Prediction duels do not require you to split coins. Simply place your bets and wait for the result. Beware - 1X and X2 bets are not allowed in prediction duels.\n\n"+
                                "Bravery duels are a high risk, high reward type of duel. You place a single bet and if you gather more points than your rival, you take it all.",
                                14,
                                FontWeight.normal,
                                Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
        
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
        
            ToggleButtons(
              onPressed: (int index) {
                setState(() {
                  setSelected(index);
                });
              },
              borderRadius: toggleButtonBorderRadius,
              fillColor: Theme.of(context).colorScheme.tertiary,
              constraints: BoxConstraints.expand(
                  width: textFieldWidth / 3, height: 40,),
              isSelected: _selected,
              children: [
                getTabWidget("Weighted", 5, _selected[0],
                    Theme.of(context).colorScheme.primary,),
                getTabWidget("Prediction", 5, _selected[1],
                    Theme.of(context).colorScheme.primary,),
                getTabWidget("Bravery", 5, _selected[2],
                    Theme.of(context).colorScheme.primary,),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: textFieldWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nunitoText(
                      "Invite code", 18, FontWeight.normal, Colors.black,),
                  nunitoText("Your opponent's invite code. You can find it in their profile tab",
                      14, FontWeight.normal, Colors.grey,),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: textFieldWidth,
                child: TextField(
                  controller: inviteeCodeController,
                  decoration: const InputDecoration(
                    enabledBorder: borderStyle,
                    focusedBorder: borderStyle,
                    filled: true,
                    fillColor: textFieldColor,
                    hintText: 'Invite code',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: textFieldWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nunitoText(
                      "Wager", 18, FontWeight.normal, Colors.black,),
                  nunitoText("The coin amount you are willing to put at stake", 14,
                      FontWeight.normal, Colors.grey,),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
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
                    hintText: 'Wager',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: textFieldWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nunitoText(
                      "Game count", 18, FontWeight.normal, Colors.black,),
                  nunitoText("The maximum amount of games that will be chosen for the duel", 14,
                      FontWeight.normal, Colors.grey,),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: textFieldWidth,
                child: TextField(
                  controller: gameCountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    enabledBorder: borderStyle,
                    focusedBorder: borderStyle,
                    filled: true,
                    fillColor: textFieldColor,
                    hintText: 'Max games',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: textFieldWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nunitoText("Competitions included", 18, FontWeight.normal,
                      Colors.black,),
                  nunitoText(
                      "Duel will consist of matches from these competitions",
                      14,
                      FontWeight.normal,
                      Colors.grey,),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: const Color.fromARGB(255, 255, 186, 75),
                  shape: const RoundedRectangleBorder(
                    borderRadius: buttonBorderRadius15,
                  ),
                ),
                onPressed: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: leaguePickerPopup(),
                    ),
                    useRootNavigator: false,
                  );
                },
                child: nunitoText(
                  selectedLeagues.isEmpty
                      ? 'Select competitions'
                      : 'Selected ${selectedLeagues.length} competitions',
                  15,
                  FontWeight.bold,
                  Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: const Color.fromARGB(255, 5, 160, 221),
                  shape: const RoundedRectangleBorder(
                      borderRadius: buttonBorderRadius15,),
                ),
                onPressed: () async {
                  await createDuel();
                },
                child: nunitoText(
                  'Send a challenge',
                  15,
                  FontWeight.bold,
                  Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
