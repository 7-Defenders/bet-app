import 'package:app/components/other/game_mode.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InviteCard extends StatelessWidget {

  final String player;
  final String timeLeft;
  final String details;
  final int stake;
  final double cardWidth;
  final double cardHeight;
  final GameMode gameMode;

  const InviteCard({required this.player, required this.gameMode, required this.details, required this.timeLeft, required this.stake, required this.cardHeight, required this.cardWidth,});

  Future<void> duelReject() async {
    debugPrint('Rejecting duel invite');
  }

  Future<void> duelAccept() async {
    debugPrint('Accepting duel invite');
  }

  Future<void> duelViewDetails() async {
    debugPrint('Details: $details');
  }

  @override
  Widget build(BuildContext context) {
    String title;
    Function() viewDetails;
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
        viewDetails = () {};
        accept = () {};
        reject = () {};
    }

    const inviteBorderRadius = 15.0;

    return SizedBox(
      width: cardWidth,
      height: cardHeight, 
      child: InkWell(
        onTap: viewDetails,
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
