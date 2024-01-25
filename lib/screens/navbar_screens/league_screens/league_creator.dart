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

    if (leagueNameController.text.length < 3)
    {
      if (mounted){
        Navigator.of(context, rootNavigator: true).pop();
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: resultPopup("Invalid league name", subtext: "League name must be at least 3 characters long"),
        ),
      );
      
      return;
    }

    if(leagueNameController.text.length > 25)
    {
      if (mounted){
        Navigator.of(context, rootNavigator: true).pop();
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: resultPopup("Invalid league name", subtext: "League name must be at most 25 characters long"),
        ),
      );
      return;
    }

    if(selectedLeagues.isEmpty)
    {
      if (mounted){
        Navigator.of(context, rootNavigator: true).pop();
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: resultPopup("No selected competitions", subtext: "You have selected no competitions"),
        ),
      );
      return;
    }

    try {
      if(int.parse(entryCostController.text) < 0)
      {
        if (mounted){
          Navigator.of(context, rootNavigator: true).pop();
        }
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            content: resultPopup("Invalid entry fee", subtext: "Entry fee cannot be lower than 0"),
          ),
        );
        return;
      }
    } on Exception catch (_) {
      if (mounted){
        Navigator.of(context, rootNavigator: true).pop();
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: resultPopup("Invalid entry fee", subtext: "Entry fee has to be an integer value"),
        ),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final List<String> competitions = [];
    for (final element in selectedLeagues) { 
      competitions.add(
        sportsObject.firstWhere((sport) => sport.name == element.split('/')[0]).countries
                  .firstWhere((country) => country.name == element.split('/')[1]).leagues
                  .firstWhere((league) => league.name == element.split('/')[2]).id,
      );
    }

    final body = jsonEncode(<String, dynamic>{
      'userID': uid,
      'entryCost': int.parse(entryCostController.text),
      'leagueName': leagueNameController.text,
      'competitionRefs': competitions,
      'private': _selected[0] ? null : _selected[1],
    });

    // print(body);
    final response = await http.post(
      Uri.parse('https://bet-app-e520a.ew.r.appspot.com/v1/leagues'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    print("${response.statusCode}, ${response.body}");

    if (mounted){
      Navigator.of(context).pop();
    }

    switch(response.statusCode){
      case 400:
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            content: resultPopup("Bad request", subtext: "Incorrect data"),
          ),
        );
      case 500:
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            content: resultPopup("Server error", subtext: "There was an error on our side. Sorry!"),
          ),
        );
      case 200:
    }
  }

  Widget resultPopup(String text, {String? subtext, double height=120.0, double width=300.0}){
    final closePopupButton = 
      ElevatedButton(
        onPressed: () {
          setState(() {});
          Navigator.of(context, rootNavigator: true).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 96, 179, 255),
        ),
        child: nunitoText('Close', 14, FontWeight.bold, Colors.white),
      );
    
    final childWidget = 
      subtext == null ?
        Column(
          children: [
            nunitoText(text, 18, FontWeight.bold, Colors.black),
            const Spacer(),
            closePopupButton,
          ],
        )
          :
        Column(
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

  Widget leaguePickerPopup({double height=300.0, double width=300.0}) {
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
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 96, 179, 255),
            ),
            child: nunitoText('Close', 14, FontWeight.bold, Colors.white),
          ),
        ],
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
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: nunitoText('League Creator', 24, FontWeight.bold, Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
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
              const SizedBox(
                  height: 20,
              ),
              SizedBox(
                width: textFieldWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    nunitoText("League Name", 18, FontWeight.normal, Colors.black),
                    nunitoText("This name will be visible in league overview", 14, FontWeight.normal, Colors.grey),
                    const SizedBox(height: 8,),
                  ],
                ),
              ),
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
              const SizedBox(
                  height: 20,
              ),
              SizedBox(
                width: textFieldWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    nunitoText("Entry fee", 18, FontWeight.normal, Colors.black),
                    nunitoText("Mandatory fee to enter the league", 14, FontWeight.normal, Colors.grey),
                    const SizedBox(height: 8,),
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
                      hintText: 'Entry fee',
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
                    nunitoText("Competitions included", 18, FontWeight.normal, Colors.black),
                    nunitoText("Select competitions players will gain points for", 14, FontWeight.normal, Colors.grey),
                    const SizedBox(height: 8,),
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
                    selectedLeagues.isEmpty ? 'Select competitions' : 'Selected ${selectedLeagues.length} competitions', 15, FontWeight.bold, Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: const Color.fromARGB(255, 5, 160, 221),
                  shape: const RoundedRectangleBorder(borderRadius: buttonBorderRadius15),
                ),
                onPressed: () async {
                  await createLeague();
                },
                child: nunitoText(
                  'Create league', 15, FontWeight.bold, Colors.white,
                ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
