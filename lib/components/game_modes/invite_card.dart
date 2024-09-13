// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:app/components/other/game_mode.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class InviteCard extends StatelessWidget {

  final String player;
  final String timeLeft;
  final Map<String, dynamic> details;
  final int stake;
  final double cardWidth;
  final double cardHeight;
  final GameMode gameMode;
  final String inviteID;
  final Function() refresh;

  const InviteCard({required this.player, required this.gameMode, required this.details,
   required this.timeLeft, required this.stake, required this.cardHeight,
   required this.cardWidth, required this.inviteID, required this.refresh,});

  Future<void> duelReject() async {
    debugPrint('Rejecting duel invite');

    final body = {
      'inviteeID': Globals.uid,
      'duelID': inviteID,
    };

    final headers = <String, String>{'Content-Type': 'application/json; charset=UTF-8',};

    final uri = Uri.parse('https://flask-vhn3gxevdq-ew.a.run.app/v1/duels');

    final response = await http.delete(uri, headers: headers, body: jsonEncode(body));

    switch (response.statusCode) {
      case 200:
        debugPrint('Invite declined');
        refresh();
      case 401:
        debugPrint('Unauthorized');
      default:
        debugPrint('Failed to decline invite');
    }

  }

  Future<void> duelAccept() async {
    debugPrint('Accepting duel invite');

    final body = {
      'inviteeID': Globals.uid,
      'duelID': inviteID,
    };

    final headers = <String, String>{'Content-Type': 'application/json; charset=UTF-8',};

    final uri = Uri.parse('https://flask-vhn3gxevdq-ew.a.run.app/v1/duels');

    final response = await http.patch(uri, headers: headers, body: jsonEncode(body));

      print(response.body);
    switch (response.statusCode) {
      case 200:
        debugPrint('Invite accepted');
        refresh();
      case 402:
        debugPrint('Not enough coins');
      default:
        debugPrint('Failed to accept invite');
    }
  }

  Future<void> duelViewDetails(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
      return AlertDialog(
        title: nunitoText('Duel Details', 20, FontWeight.bold, Colors.black),
        content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Stack(
              children:[
                Align(
                  alignment: Alignment.centerLeft,
                  child: nunitoText('Stake', 16, FontWeight.bold, Colors.black),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: nunitoText(stake.toString(), 16, FontWeight.normal, Colors.black),
                ),
              ],
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: nunitoText("Game count", 16, FontWeight.bold, Colors.black),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: nunitoText(details["gameCount"].toString(), 16, FontWeight.normal, Colors.black),
                ),
              ],
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: nunitoText("Competitions", 16, FontWeight.bold, Colors.black),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(details["competitions"].length as int, (index) {
                    return nunitoText(details["competitions"][index].toString(), 16, FontWeight.normal, Colors.black, textAlign: TextAlign.right);
                  }),
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
        actions: <Widget>[
        TextButton(
          child: nunitoText('Close', 14, FontWeight.bold, Colors.black),
          onPressed: () {
          Navigator.of(context).pop();
          },
        ),
        ],
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String title;
    Function(BuildContext) viewDetails;
    Function() accept;
    Function() reject;

    switch (gameMode) {
      case GameMode.duel:
        title = 'DUEL';
        viewDetails = duelViewDetails;
        accept = duelAccept;
        reject = duelReject;
      default:
        title = 'ERROR';
        viewDetails = (context) {};
        accept = () {};
        reject = () {};
    }

    const inviteBorderRadius = 15.0;

    return SizedBox(
      width: cardWidth,
      height: cardHeight, 
      child: InkWell(
        onTap: () => viewDetails(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(inviteBorderRadius),
            side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 4.0),
          ),
          elevation: 5,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
                child: nunitoText(title, 16, FontWeight.normal, Colors.black),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(inviteBorderRadius - 4),
                    ),
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: nunitoText(timeLeft, 16, FontWeight.normal, Colors.black,),
                  ),
                ),
              ),

              Align(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(inviteBorderRadius - 4),
                      ),
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: nunitoText(player, 14, FontWeight.bold, Colors.black,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: nunitoText("has challenged you", 14, FontWeight.normal, Colors.black),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'lib/assets/images/game_modes/invite_bottom.svg',
                      // height: cardHeight,
                      width: cardWidth,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: reject,
                          child: SizedBox(
                            width: cardWidth * 0.3,
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth * 0.3,
                          child: nunitoText('$stake\nStake', 12, FontWeight.bold, Colors.white, textAlign: TextAlign.center),
                        ),
                        InkWell(
                          onTap: accept,
                          child: SizedBox(
                            width: cardWidth * 0.3,
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
