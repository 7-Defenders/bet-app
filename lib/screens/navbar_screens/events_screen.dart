// ignore_for_file: avoid_dynamic_calls

import 'dart:async';

import 'package:app/components/events_screen/bet_preview.dart';
import 'package:app/components/events_screen/button_with_bets.dart';
import 'package:app/components/other/appbar/balance_widget.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/globals.dart';
import 'package:app/models/football_event.dart';
import 'package:app/models/structure.dart';
import 'package:app/providers/button_states_provider.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
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
  List<Widget> displayedMatches = [];
  Sport? selectedSport;
  Country? selectedCountry;
  League? selectedLeague;

  @override
  void initState() {
    super.initState();
    loadStructure();
    //debugPrint('LeaguesScreenState key: ${widget.key}');
  }

  void handleRemoveMatch(BuildContext context, String eventName) {
    //for each element in displayed check eventName and imf matches change initialSelection to null
    bool found = false;
    final buttonStatesProvider = context.read<ButtonStatesProvider>();
    //only check for first one that matches the event name
    for (final element in displayedMatches) {
      if ((element is BetPreviewWidget) && !found) {
        debugPrint('checking ${element.eventName}' ' for $eventName');
        if (element.eventName == eventName) {
          debugPrint('resetting $eventName');
          debugPrint("all element properties: ${element.onReset}");
          element.onReset?.call();
          buttonStatesProvider.removeButtonState(eventName);
          found = true;
        }
      }
    }
  }

  void rebuild() {
    setState(() {
      displayedMatches.clear();
      if (selectedLeague != null) {
        fetchMatchesGivenLeague(selectedLeague!.id);
      }
      build(context);
    });
  }

  Future<void> loadStructure() async {
    setState(() {
      structure = sportsObject;
    });
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
      final uri =
          'https://flask-vhn3gxevdq-ew.a.run.app/v1/competitions/$league';
      final response = await Globals.performCall(uri);

      displayedMatches.clear();

      setState(() {
        final buttonStatesProvider = context.read<ButtonStatesProvider>();

        final List<FootballEvent> fe = footballEventFromJson(response);

        fe
            .where((element) => element.date.isAfter(DateTime.now()))
            .forEach((element) {
          displayedMatches.add(
            BetPreviewWidget(
              eventName: '${element.homename} - ${element.awayname}',
              eventDetails: element.date.toString(),
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
                final String date = element.date.toString();

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

                //debugPrint("Selected option: $selectedOption" + " key: $key");

                //print selectedOption and buttonStatesProvider.buttonStates[key]
                // debugPrint("Selected option: $selectedOption" +
                //     " buttonStatesProvider.buttonStates[key]: " +
                //     "${buttonStatesProvider.buttonStates[key]}");

                final currentOptionAndOdds =
                    buttonStatesProvider.buttonStates[key]?.split(',');
                final currentOption = currentOptionAndOdds != null
                    ? currentOptionAndOdds[0]
                    : null;

                //debugPrint("Current option: $currentOption");

                if (buttonStatesProvider.buttonStates.containsKey(key) &&
                    selectedOption == currentOption) {
                  buttonStatesProvider.removeButtonState(key);
                } else {
                  buttonStatesProvider.updateButtonState(
                    key,
                    '$selectedOption,$odds,$matchRef,$date',
                  );
                }

                //debugPrint(
                //"ButtonStatesProvider values: ${buttonStatesProvider.buttonStates}");
                //print whole map
              },
              initialSelection: buttonStatesProvider
                  .buttonStates['${element.homename} - ${element.awayname}']
                  ?.split(',')[0],
            ),
          );

          debugPrint(displayedMatches.length.toString());
        });
      });
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
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
                      ? Theme.of(context).colorScheme.surface
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
                          color: Theme.of(context).colorScheme.onSurface,
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
                              Theme.of(context).colorScheme.onSurface,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                      color: Theme.of(context).colorScheme.tertiary,
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
          Positioned(
            top: MediaQuery.of(context).padding.top + 3,
            right: 16,
            child: Consumer<UserDataProvider>(
              builder: (context, userDataProvider, child) {
                return BalanceWidget(
                  bgColor: const Color.fromARGB(255, 255, 163, 21),
                  //get balance from userdataprovider
                  balance: userDataProvider.userData!.balance.toInt(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ButtonWithBets(
        onRemoveMatch: (String matchRef) =>
            handleRemoveMatch(context, matchRef),
      ),
    );
  }
}
