import 'package:app/components/history_screen/glowing_circle.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/models/bet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HistoryBetWidget extends StatelessWidget {
  final Bet bet;
  const HistoryBetWidget({super.key, required this.bet});

  @override
  Widget build(BuildContext context) {
    final betSplit = bet.betodds.toString().split('.');
    final oddsTrailingZeros = "${betSplit[0]}.${betSplit[1].padRight(2, '0')}";
    final winningsTrailingZeros = bet.result == null ? "-" : bet.result == 1 ? "${(bet.amount! * bet.betodds!).round()}" : "0";

    final cardHeight = MediaQuery.of(context).size.height * 0.1;
    final cardWidth = MediaQuery.of(context).size.width * 0.9;

    String sportSvg;
    switch(bet.sport!){
      case "Football": sportSvg = "lib/assets/images/futbol-regular.svg";
      case "Basketball": sportSvg = "lib/assets/images/basketball-solid.svg";
      default: sportSvg = "lib/assets/images/table-tennis-paddle-ball-solid.svg"; break;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orange,
            width: 5,
          ),
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(sportSvg, width: cardWidth * 0.1,),
            SizedBox(width: cardWidth * 0.02,),
            SizedBox(
              width: cardWidth * 0.6,
              height: cardHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: nunitoText(
                      bet.game != null ? '${bet.game!.homename} - ${bet.game!.awayname}' : 'N/A',
                      16,
                      FontWeight.bold,
                      Colors.black,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  nunitoText("${bet.competition}\n${bet.game == null ? "Date N/A" : bet.game!.date}", 11, FontWeight.normal, Colors.black),
                  nunitoText("Bet: ${bet.bet} at $oddsTrailingZeros | Stake: ${bet.amount}", 12, FontWeight.bold, Colors.black),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: cardWidth * 0.15,
              child: Column(
                children: [
                  nunitoText(winningsTrailingZeros, 16, FontWeight.bold, Colors.black),
                  SizedBox(height: cardHeight * 0.15,),
                  if (bet.result == null)
                    GlowingCircle(color: Colors.yellow.withOpacity(0.7))
                  else if (bet.result == 1)
                    GlowingCircle(color: Colors.green.withOpacity(0.7))
                  else
                    GlowingCircle(color: Colors.red.withOpacity(0.7)),
                ], 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
