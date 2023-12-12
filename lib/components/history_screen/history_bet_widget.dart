import 'package:app/components/bet.dart';
import 'package:app/components/history_screen/glowing_circle.dart';
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
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${bet.game.awayname} - ${bet.game.homename}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                if (bet.result == null)
                  const GlowingCircle(color: Colors.yellow)
                else if (bet.result == bet.bet)
                  const GlowingCircle(color: Colors.green)
                else
                  const GlowingCircle(color: Colors.red)
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${bet.amount} pts',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  bet.result == null
                      ? 'pending'
                      : (bet.result == bet.bet)
                          ? 'won: ${bet.betOdds * bet.amount} pts'
                          : '0 pts',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
