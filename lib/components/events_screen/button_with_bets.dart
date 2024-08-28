import 'dart:convert';

import 'package:app/components/events_screen/bet_maker.dart';
import 'package:app/components/events_screen/bet_preview.dart';
import 'package:app/globals.dart';
import 'package:app/providers/button_states_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ButtonWithBets extends StatefulWidget {
  const ButtonWithBets({super.key});

  @override
  State<ButtonWithBets> createState() => _ButtonWithBetsState();
}

class _ButtonWithBetsState extends State<ButtonWithBets> {
  final Map<String, TextEditingController> amountControllers = {};
  List<BetPreviewWidget> chosenMatches = [];
  List<BetPreviewWidget> displayedMatches = [];

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
              final split = entry.value.split(',');
              debugPrint(split.toString());
              final betType = split[0];
              final double odds = double.parse(split[1]);
              final matchRef = split[2];
              final date = split[3];

              debugPrint("matchRef: $matchRef");

              final amountController = amountControllers.putIfAbsent(
                entry.key,
                () => TextEditingController(),
              );

              return BetMaker(
                gameName: gameName,
                betType: betType,
                odds: odds,
                date: date,
                matchRef: matchRef,
                amountController: amountController,
                onRemove: () {
                  final matchId = entry.key;
                  chosenMatches
                      .removeWhere((element) => element.eventName == matchId);
                  buttonStatesProvider.removeButtonStateAndRefresh(matchId);
                },
                createBet: createBet,
              );
            },
          ),
        );
      },
    );
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
    final String uid = Globals.uid;

    debugPrint(
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

    const uri = 'https://bet-app-e520a.ew.r.appspot.com/v1/bets';

    final response = await http.post(
      Uri.parse(
        uri,
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

    debugPrint(response.body);
    //debugPrint(response.statusCode.toString());

    if (response.statusCode != 201) {
      debugPrint("Failed to create bet");
      return false;
    } else {
      // await Globals.saveNewBet("$uri/$uid", response.body);
      debugPrint("Bet created successfully");
      Globals.hasNewBet = true;
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          context.watch<ButtonStatesProvider>().buttonStatesNotifier,
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
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    child: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: 40,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
