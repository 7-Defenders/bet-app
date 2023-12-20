import 'package:app/components/bet.dart';
import 'package:app/components/history_screen/glowing_circle.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:flutter/material.dart';

class HistoryBetWidget extends StatelessWidget {
  final Bet bet;
  const HistoryBetWidget({super.key, required this.bet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                nunitoText(
                  '${bet.game.awayname} - ${bet.game.homename}',
                  16,
                  FontWeight.bold,
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                ),
                const SizedBox(height: 5),
                if (bet.result == null)
                  GlowingCircle(color: Colors.yellow.withOpacity(0.7))
                else if (bet.result == bet.bet)
                  GlowingCircle(color: Colors.green.withOpacity(0.7))
                else
                  GlowingCircle(color: Colors.red.withOpacity(0.7)),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                nunitoText(
                  '${bet.amount} pts',
                  16,
                  FontWeight.normal,
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                ),
                const SizedBox(height: 5),
                nunitoText(
                  bet.result == null
                      ? 'pending'
                      : (bet.result == bet.bet)
                          ? 'won: ${bet.betOdds * bet.amount} pts'
                          : '0 pts',
                  20,
                  FontWeight.normal,
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
