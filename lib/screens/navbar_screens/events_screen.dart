import 'dart:async';
import 'dart:convert';

import 'package:app/components/events_screen/bet_preview.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/models/football_event.dart';
import 'package:app/models/structure.dart';
import 'package:app/providers/button_states_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => EventsScreenState();
}

class EventsScreenState extends State<EventsScreen> {
  final Map<String, TextEditingController> amountControllers = {};
  static final GlobalKey<EventsScreenState> key =
      GlobalKey<EventsScreenState>();

  List<Sport> structure = [];
  List<BetPreviewWidget> displayedMatches = [];
  Sport? selectedSport;
  Country? selectedCountry;
  League? selectedLeague;

  List<BetPreviewWidget> chosenMatches = [];

  @override
  void initState() {
    super.initState();
    loadStructure();
    //print('LeaguesScreenState key: ${widget.key}');
  }

  void rebuild() {
    setState(() {
      displayedMatches.clear();
      if (selectedLeague != null) {
        fetchMatchesGivenLeague(selectedLeague!.id);
      }
    });
  }

  Future<void> loadStructure() async {
    setState(() {
      structure = sportsObject;
    });
  }

  Future<bool> createBet(
    int amount,
    String betType,
    double betOdds,
    String matchRef,
  ) async {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Center(
    //       child: LoadingAnimationWidget.hexagonDots(
    //         color: Theme.of(context).colorScheme.primary,
    //         size: 55,
    //       ),
    //     );
    //   },
    // );
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    print(
      jsonEncode(
        <String, dynamic>{
          'userID': uid,
          'amount': amount,
          'bet': betType,
          'betodds': betOdds,
          'gameRef': matchRef,
          'result': null,
        },
      ),
    );

    final response = await http.post(
      Uri.parse(
        'https://bet-app-e520a.ew.r.appspot.com/v1/bets', // Change the endpoint to /bets
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'userID': uid,
          'amount': amount,
          'bet': betType,
          'betodds': betOdds,
          'gameRef': matchRef,
          'result': null,
        },
      ),
    );

    print(response.body);

    return (response.statusCode == 201);
  }

  Future<void> fetchMatchesGivenLeague(String league) async {
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
      barrierDismissible: false,
      useRootNavigator: false,
    );

    try {
    final response = await http.get(
      Uri.parse(
        'https://bet-app-e520a.ew.r.appspot.com/v1/v1/competitions/$league',
      ),
    );
    print(response.body);

    displayedMatches.clear();

    setState(() {
      final buttonStatesProvider = context.read<ButtonStatesProvider>();

      footballEventFromJson(response.body).forEach(
        (element) => displayedMatches.add(
          BetPreviewWidget(
            eventName: '${element.homename} - ${element.awayname}',
            eventDetails: element.date,
            bets: {
              '1': element.homeodds,
              '1X': element.homedrawodds,
              'X': element.tieodds,
              'X2': element.drawawayodds,
              '2': element.awayodds,
            },
            onOptionSelected: (String? selectedOption) {
              final String key = '${element.homename} - ${element.awayname}';
              final double odds;
              final String matchRef = element.matchRef;

              switch (selectedOption) {
                case '1':
                  odds = element.homeodds;
                case 'X':
                  odds = element.tieodds;
                case '2':
                  odds = element.awayodds;
                case '1X':
                  odds = element.homedrawodds;
                case 'X2':
                  odds = element.drawawayodds;
                default:
                  odds = 0;
              }
              //replace this with proper way to fetch odds

              //print("Selected option: $selectedOption" + " key: $key");

              //print selectedOption and buttonStatesProvider.buttonStates[key]
              // print("Selected option: $selectedOption" +
              //     " buttonStatesProvider.buttonStates[key]: " +
              //     "${buttonStatesProvider.buttonStates[key]}");

              final currentOptionAndOdds =
                  buttonStatesProvider.buttonStates[key]?.split(',');
              final currentOption =
                  currentOptionAndOdds != null ? currentOptionAndOdds[0] : null;

              //print("Current option: $currentOption");

              if (buttonStatesProvider.buttonStates.containsKey(key) &&
                  selectedOption == currentOption) {
                buttonStatesProvider.removeButtonState(key);
              } else {
                buttonStatesProvider.updateButtonState(
                  key,
                  '$selectedOption,$odds,$matchRef',
                );
              }
              //print(
              //"ButtonStatesProvider values: ${buttonStatesProvider.buttonStates}");
              //print whole map
            },
            initialSelection: buttonStatesProvider
                .buttonStates['${element.homename} - ${element.awayname}']
                ?.split(',')[0],
          ),
        ),
      );
    });
    } finally {
      if (mounted) {
        if (Navigator.of(context, rootNavigator: true).canPop()){
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    }
  }

  Widget buildListView(
    List<dynamic> items,
    dynamic selectedItem,
    void Function(dynamic) onTap,
  ) {
    return SizedBox(
      height: 75,
      width: double.infinity,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 5),
        itemBuilder: (context, index) {
          final item = items[index];
          // every item has a name - TODO workaround linter for this, maybe cast
          final String itemName = item.name as String;
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 5),
            child: GestureDetector(
              onTap: () {
                onTap(item);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  width: 115,
                  color: item == selectedItem
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.error,
                  child: Column(
                    children: [
                      if (item is Country || item is League)
                        SvgPicture.asset(
                          item.svgPath as String,
                          width: (item is Country) ? 45 : 40,
                          height: (item is Country) ? 38 : 38,
                        )
                      else if (item is Sport)
                        Icon(
                          item.icon,
                          color: Theme.of(context).colorScheme.onBackground,
                          size: 35,
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: nunitoText(
                              itemName,
                              14,
                              FontWeight.normal,
                              Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSportListView() {
    return buildListView(
      structure.map((sport) => sport).toList(),
      selectedSport,
      (sport) {
        setState(() {
          selectedSport = sport as Sport;
          selectedCountry = null;
          selectedLeague = null;
          displayedMatches.clear();
        });
      },
    );
  }

  Widget buildCountryListView() {
    final List<Country> countries = [];

    for (final Sport sport in structure) {
      countries.addAll(sport.countries);
    }

    return buildListView(
      countries.map((country) => country).toList(),
      selectedCountry,
      (country) {
        setState(() {
          selectedCountry = country as Country;
          selectedLeague = null;
          displayedMatches.clear();
        });
      },
    );
  }

  Widget buildLeagueListView() {
    final leagues = structure
        .firstWhere(
          (sport) => sport.name == selectedSport?.name,
          orElse: () => Sport(name: '', countries: [], icon: Icons.abc),
        )
        .countries
        .firstWhere(
          (country) => country.name == selectedCountry?.name,
          orElse: () => Country(name: '', leagues: [], svgPath: ''),
        )
        .leagues
        .map((league) => league)
        .toList();

    return buildListView(
      leagues,
      selectedLeague,
      (league) {
        setState(() {
          selectedLeague = league as League;
          fetchMatchesGivenLeague(selectedLeague!.id);
        });
      },
    );
  }

  void onMakeBetPressed() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final buttonStatesProvider = Provider.of<ButtonStatesProvider>(context);
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            itemCount: buttonStatesProvider.buttonStates.length,
            itemBuilder: (context, index) {
              final entry =
                  buttonStatesProvider.buttonStates.entries.elementAt(index);
              final gameName = entry.key;
              final betType = entry.value.split(',')[0];
              final double odds = double.parse(entry.value.split(',')[1]);
              final matchRef = entry.value.split(',')[2];

              print("matchRef: $matchRef");

              final amountController = amountControllers.putIfAbsent(
                entry.key,
                () => TextEditingController(),
              );

              return ListTile(
                title: Text('Match: $gameName'),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text('Option: $betType'),
                    ),
                    Text('Odds: $odds'),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        final matchId = entry.key;

                        //print ("matchId: $matchId");

                        //print ("matchId: $matchId");

                        chosenMatches.removeWhere(
                          (element) => element.eventName == matchId,
                        );

                        buttonStatesProvider
                            .removeButtonStateAndRefresh(matchId);

                        //setState(() {});
                        rebuild();
                      },
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        decoration: const InputDecoration(
                          hintText: 'Amount',
                        ),

                        // Configure your TextField here.
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final int amount = int.parse(amountController.text);
                        final Future<bool> betFuture = createBet(
                          amount, // Replace with actual amount
                          betType, // Replace with actual bet type
                          odds, // Replace with actual bet odds
                          matchRef, // Replace with actual game reference
                        );

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FutureBuilder<bool>(
                              future: betFuture,
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<bool> snapshot,
                              ) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const AlertDialog(
                                    title: Text('Placing bet...'),
                                    content: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content:
                                        const Text('Failed to create bet.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  final bool success = snapshot.data ?? false;
                                  return AlertDialog(
                                    title: const Text('Bet Status'),
                                    content: Text(
                                      success
                                          ? 'Bet created successfully.'
                                          : 'Failed to create bet.',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                      child: const Text('Place bet'),
                      // onPressed: () async {
                      // final int amount = int.parse(amountController.text);
                      // final bool success = await createBet(
                      //   amount,
                      //   betType,
                      //   odds,
                      //   matchRef,
                      // );

                      // if (success) {
                      //   chosenMatches.removeWhere(
                      //     (element) => element.eventName == gameName,
                      //   );

                      //   print("gameName: $gameName");
                      //   print("chosenMatches: $chosenMatches");

                      //   buttonStatesProvider
                      //       .removeButtonStateAndRefresh(gameName);
                      //   rebuild();
                      // } else {
                      //   print('Failed to create bet.');
                      // }

                      //   },
                      //   child: const Text('Place bet'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("LeaguesScreen context: $context");
    // print(
    //     "Provider available: ${Provider.of<ButtonStatesProvider>(context, listen: false) != null}");
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // filters
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: selectedSport == null
                      ? 140
                      : selectedCountry == null
                          ? 220
                          : selectedLeague == null
                              ? 290
                              : 290,
                  curve: Curves.easeInOut,
                  child: SingleChildScrollView(
                    // this helps avoid overflow during animation
                    child: Container(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 55,
                        bottom: 10,
                      ),
                      child: Column(
                        children: [
                          buildSportListView(),
                          if (selectedSport != null)
                            buildCountryListView().animate(
                              effects: [
                                const SlideEffect(
                                  duration: Duration(milliseconds: 250),
                                  begin: Offset(0, -0.5),
                                  end: Offset.zero,
                                ),
                                const FadeEffect(
                                  duration: Duration(milliseconds: 250),
                                  begin: 0,
                                  end: 1,
                                ),
                              ],
                            ),
                          if (selectedCountry != null) buildLeagueListView(),
                        ],
                      ),
                    ),
                  ),
                ),
                // matches
                Consumer<ButtonStatesProvider>(
                  builder: (context, buttonStatesProvider, child) {
                    return Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          ...displayedMatches,
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: context.watch<ButtonStatesProvider>().buttonStatesNotifier,
        builder: (context, Map<String, String> value, child) {
          return value.isNotEmpty
            ? Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: 65,
                height: 65,
                child: FloatingActionButton(
                  elevation: 10,
                  onPressed: onMakeBetPressed,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 40,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
            )
            : const SizedBox.shrink();
        },
      ),
    );
  }
}
