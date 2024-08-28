import 'package:app/components/events_screen/bet_preview.dart';
import 'package:app/components/events_screen/button_with_bets.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/globals.dart';
import 'package:app/models/football_event.dart';
import 'package:app/providers/button_states_provider.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> displayedMatches = [];

  void goHome2(BuildContext context) {
    GoRouter.of(context).go('/home/2');
  }

  Future<void> logOutUser() async {
    Provider.of<UserDataProvider>(context, listen: false).userData = null;
    await FirebaseAuth.instance.signOut();
  }

  Future<void> getPopularMatches() async {
      const uri =
          'https://flask-vhn3gxevdq-ew.a.run.app/v1/popular_bets';
      final response = await Globals.performCall(uri);

      displayedMatches.clear();
      final buttonStatesProvider = context.read<ButtonStatesProvider>();

      setState(() {
        final List<FootballEvent> fe = footballEventFromJson(response);

        fe.where((element) => element.date.isAfter(DateTime.now()))
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
                final currentOption = currentOptionAndOdds != null
                    ? currentOptionAndOdds[0]
                    : null;

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

  @override
  void initState() {
    super.initState();
    getPopularMatches();
  }

  @override
  Widget build(BuildContext context) {
    final usableWidth = MediaQuery.of(context).size.width * 0.9;
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
                buildSection(
                  "Invites",
                  usableWidth, //this has no impact?
                  cardHeight,
                  cardWidth,
                  [
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
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                  ],
                  hidden: true,
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
                      child: const Card(),
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
                  hidden: true,
                  description: "Checkout other game modes we have on offer",
                ),
                buildSection(
                  "Popular",
                  usableWidth,
                  cardHeight,
                  cardWidth,
                  displayedMatches,
                  description: "Most popular events today",
                  vertical: true,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const ButtonWithBets(),
    );
  }
}
