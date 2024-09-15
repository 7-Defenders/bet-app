// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:app/components/events_screen/bet_preview.dart';
import 'package:app/components/events_screen/button_with_bets.dart';
import 'package:app/components/game_modes/game_card.dart';
import 'package:app/components/game_modes/gamemode_card.dart';
import 'package:app/components/game_modes/invite_card.dart';
import 'package:app/components/other/game_mode.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/globals.dart';
import 'package:app/models/duel.dart';
import 'package:app/models/football_event.dart';
import 'package:app/models/invite.dart';
import 'package:app/providers/button_states_provider.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ButtonStatesProvider? buttonStatesProvider;
  List<Widget> displayedMatches = [];
  Invites displayedInvites = Invites();
  List<Duel> ongoingGames = [];

  void goHome2(BuildContext context) {
    GoRouter.of(context).go('/home/2');
  }

  Future<void> fetchCurrentGames() async {
    final uriInvites =
        'https://flask-vhn3gxevdq-ew.a.run.app/v1/invites/${Globals.uid}';
    final uriGames =
        'https://flask-vhn3gxevdq-ew.a.run.app/v1/games/${Globals.uid}';
    final responseInvites =
        await Globals.performCall(uriInvites, forceCall: true);
    final responseGames = await Globals.performCall(uriGames, forceCall: true);

    debugPrint("responseInvites: $responseInvites");
    debugPrint("responseGames: $responseGames");
    displayedInvites = Invites();

    setState(() {
      displayedInvites = Invites.fromJson(responseInvites);
      for (final game in jsonDecode(responseGames)["duels"] as List) {
        ongoingGames.add(Duel.fromJson(game as Map<String, dynamic>));
      }
    });
  }

  Future<void> goToDuelCreator(BuildContext context) async {
    final shouldRefresh = await context.push<bool>('/home/duels_creator');
    if (shouldRefresh ?? false) {
      setState(() {
        fetchCurrentGames();
      });
    }
  }

  void handleRemoveMatch(BuildContext context, String eventName) {
    //for each element in displayed check eventName and imf matches change initialSelection to null
    bool found = false;
    final buttonStatesProvider = context.read<ButtonStatesProvider>();
    //only check for first one that matches the event name
    for (final element in displayedMatches) {
      if ((element is BetPreviewWidget) && !found) {
        //print('checking ${element.eventName}' ' for $eventName');
        if (element.eventName == eventName) {
          //print('resetting $eventName');
          //print("all element properties: ${element.onReset}");
          element.onReset?.call();
          buttonStatesProvider.removeButtonState(eventName);
          found = true;
        }
      }
    }
  }

  Future<void> logOutUser() async {
    Provider.of<UserDataProvider>(context, listen: false).userData = null;
    await FirebaseAuth.instance.signOut();
  }

  Future<void> getPopularMatches() async {
    const uri = 'https://flask-vhn3gxevdq-ew.a.run.app/v1/popular_bets';
    final response = await Globals.performCall(uri);

    displayedMatches.clear();
    final buttonStatesProvider = context.read<ButtonStatesProvider>();

    setState(() {
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

              final currentOptionAndOdds =
                  buttonStatesProvider.buttonStates[key]?.split(',');
              final currentOption =
                  currentOptionAndOdds != null ? currentOptionAndOdds[0] : null;

              if (buttonStatesProvider.buttonStates.containsKey(key) &&
                  selectedOption == currentOption) {
                buttonStatesProvider.removeButtonState(key);
              } else {
                buttonStatesProvider.updateButtonState(
                  key,
                  '$selectedOption,$odds,$matchRef,$date',
                );
              }
            },
            initialSelection: buttonStatesProvider
                .buttonStates['${element.homename} - ${element.awayname}']
                ?.split(',')[0],
          ),
        );
      });
    });
  }

  Widget buildSection(
    String title,
    double usableWidth,
    double cardHeight,
    double cardWidth,
    List<Widget> widgets, {
    String? description,
    bool vertical = false,
    bool hidden = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        nunitoText(title, 18, FontWeight.bold, Colors.black),
        if (description != null)
          nunitoText(description, 14, FontWeight.normal, Colors.grey)
        else
          const SizedBox(),
        const SizedBox(
          height: 8,
        ),
        Stack(
          children: [
            if (vertical)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widgets,
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widgets,
                ),
              ),
            if (hidden)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                  width: usableWidth,
                  height: cardHeight,
                  child: Center(
                    child: nunitoText(
                      'Coming soon',
                      18,
                      FontWeight.bold,
                      Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> showDuelMatches(BuildContext context, Duel duel) async {
    //make copy of buttonStatesProvider
    final ButtonStatesProvider buttonStatesProvider =
        Provider.of(context, listen: false);
    final List<FootballEvent>? matches = duel.games;
    final List<BetPreviewWidget> matchCards = [];
    // convert matches to bet preview widgets
    for (final match in matches!) {
      matchCards.add(
        BetPreviewWidget(
          eventName: '${match.homename} - ${match.awayname}',
          eventDetails: match.date.toString(),
          bets: {
            '1': match.homeodds,
            '1X': match.homedrawodds,
            'X': match.tieodds,
            'X2': match.drawawayodds,
            '2': match.awayodds,
          },
          onOptionSelected: (String? selectedOption) {
            final String key = '${match.homename} - ${match.awayname}';
            final double odds;
            final String matchRef = match.matchRef;
            final String date = match.date.toString();

            switch (selectedOption) {
              case '1':
                odds = match.homeodds;
              case 'X':
                odds = match.tieodds;
              case '2':
                odds = match.awayodds;
              case '1X':
                odds = match.homedrawodds;
              case 'X2':
                odds = match.drawawayodds;
              default:
                odds = 0;
            }

            final currentOptionAndOdds =
                buttonStatesProvider.buttonStates[key]?.split(',');
            final currentOption =
                currentOptionAndOdds != null ? currentOptionAndOdds[0] : null;

            if (buttonStatesProvider.buttonStates.containsKey(key) == true &&
                selectedOption == currentOption) {
              buttonStatesProvider.removeButtonState(key);
            } else {
              buttonStatesProvider.updateButtonState(
                key,
                '$selectedOption,$odds,$matchRef,$date',
              );
            }
          },
          initialSelection: buttonStatesProvider
              .buttonStates['${match.homename} - ${match.awayname}']
              ?.split(',')[0],
        ),
      );
    }
    debugPrint('matchCards: $matchCards');
    //go to another screen to display the matches
    final shouldRefresh = await context.push<bool>(
      '/home/duel_matches',
      extra: {
        'betPreviewWidgets': matchCards,
        'buttonStatesProvider': buttonStatesProvider,
        'duelID': duel.duelID!,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPopularMatches();
    fetchCurrentGames();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('displayedInvites: $displayedInvites');
    final usableWidth = MediaQuery.of(context).size.width * 0.95;
    final cardWidth = usableWidth * 0.45;
    final cardHeight = MediaQuery.of(context).size.height * 0.15;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: nunitoText('Home', 26, FontWeight.bold, Colors.black),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: usableWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (displayedInvites.duels?.isEmpty ?? true)
                  const SizedBox()
                else
                  buildSection(
                    "Invites",
                    usableWidth, //this has no impact?
                    cardHeight,
                    cardWidth,
                    List.generate(
                      displayedInvites.duels?.length ?? 0,
                      (index) {
                        final duel = displayedInvites.duels![index];
                        return InviteCard(
                          player: duel.hostNickname ?? 'Unknown',
                          gameMode: GameMode.duel,
                          details: <String, dynamic>{
                            "gameCount": duel.gameCount,
                            "competitions": duel.competitions,
                          },
                          timeLeft: '3h',
                          stake: duel.entryCost ?? 0,
                          cardHeight: cardHeight * 1.3,
                          cardWidth: cardWidth * 1.3,
                          inviteID: duel.duelID!,
                          refresh: () async {
                            await fetchCurrentGames();
                          },
                        );
                      },
                    ),
                  ),
                if (ongoingGames.isEmpty)
                  const SizedBox()
                else
                  buildSection(
                    "Ongoing games",
                    usableWidth, //this has no impact?
                    cardHeight,
                    cardWidth,
                    List.generate(
                      ongoingGames.length,
                      (index) {
                        final duel = ongoingGames[index];
                        return GameCard(
                          title: 'DUEL',
                          opponent: duel.hostNickname ?? 'Unknown',
                          child: SvgPicture.asset(
                            'lib/assets/images/futbol-regular.svg',
                            height: cardHeight * 0.35,
                            width: cardHeight * 0.35,
                          ),
                          // onTap: () => debugPrint('tapped'),
                          onTap: () => showDuelMatches(context, duel),
                        );
                      },
                    ),
                  ),
                buildSection(
                  "Game modes",
                  usableWidth,
                  cardHeight,
                  cardWidth,
                  [
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: GamemodeCard(
                        title: "title",
                        child: SvgPicture.asset(
                          'lib/assets/images/futbol-regular.svg',
                          height: cardHeight * 0.35,
                          width: cardHeight * 0.35,
                        ),
                        onTap: () async {
                          await goToDuelCreator(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                  ],
                  // hidden: true,
                  description: "Checkout other game modes we have on offer",
                ),
                Consumer<ButtonStatesProvider>(
                  builder: (context, buttonStatesProvider, child) {
                    return buildSection(
                      "Popular",
                      usableWidth,
                      cardHeight,
                      cardWidth,
                      displayedMatches,
                      description: "Most popular events today",
                      vertical: true,
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ButtonWithBets(
        onRemoveMatch: (String matchRef) =>
            handleRemoveMatch(context, matchRef),
      ),
    );
  }
}
