import 'package:app/components/history_screen/glowing_circle.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/models/bet.dart';
import 'package:flutter/material.dart';

class HistoryBetWidget extends StatelessWidget {
  final Bet bet;
  const HistoryBetWidget({super.key, required this.bet});

  @override
  Widget build(BuildContext context) {
    final betSplit = bet.betodds.toString().split('.');
    final betString = "${betSplit[0]}.${betSplit[1].padRight(2, '0')}";

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 15),
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orange, // Add orange border color
            width: 5, // Add border width
          ),
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: <Widget>[
                  nunitoText(
                    bet.game != null ? '${bet.game!.homename} - ${bet.game!.awayname}' : 'N/A',
                    16,
                    FontWeight.bold,
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                  ),
                  const Spacer(),
                  nunitoText(betString, 18, FontWeight.bold, Colors.black),
              ],
            ),
            Row(
              children: [
                nunitoText(bet.game == null ? "Date N/A" : bet.game!.date.toString(), 12, FontWeight.normal, Colors.black),
                const Spacer(),
                if (bet.result == null)
                  GlowingCircle(color: Colors.yellow.withOpacity(0.7))
                else if (bet.result == 1)
                  GlowingCircle(color: Colors.green.withOpacity(0.7))
                else
                  GlowingCircle(color: Colors.red.withOpacity(0.7)),
              ],
            ),

                        // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     const SizedBox(height: 5),
            //     if (bet.result == null)
            //       GlowingCircle(color: Colors.yellow.withOpacity(0.7))
            //     else if (bet.result == 1)
            //       GlowingCircle(color: Colors.green.withOpacity(0.7))
            //     else
            //       GlowingCircle(color: Colors.red.withOpacity(0.7)),
            //   ],
            // ),
            // const Spacer(),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     nunitoText(
            //       'bet: ${bet.bet}; stake: ${bet.amount} pts',
            //       16,
            //       FontWeight.normal,
            //       Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
            //     ),
            //     nunitoText(
            //       bet.result == null
            //           ? 'pending'
            //           : (bet.result == 1)
            //               ? 'won: ${bet.betodds! * bet.amount!} pts'
            //               : '0 pts',
            //       20,
            //       FontWeight.normal,
            //       Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
