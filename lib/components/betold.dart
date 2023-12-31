import 'package:app/components/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BetOld {
  late num amount;
  late String bet;
  late num betOdds;
  late num? result;
  late DocumentReference gameRef;
  late Game game;

  BetOld._();

  Future<void> _complexAsyncInit() async {
    print("BetOld._complexAsyncInit called");
    final DocumentSnapshot gameSnapshot = await gameRef.get();
    final Map<String, dynamic>? gameData =
        gameSnapshot.data() as Map<String, dynamic>?;

    if (gameData != null) {
      game = Game.fromMap(gameData);
      print("game from map finished!");
    } else {
      throw Exception("Invalid game snapshot");
    }
  }

  // our own factory-like constructor
  static Future<BetOld> create(Map<String, dynamic> data) async {
    print("BetOld public factory");
    final bet = BetOld._();
    bet.amount = data['amount'] as num;
    bet.bet = data['bet'] as String;
    bet.betOdds = data['betodds'] as num;
    bet.result = data['result'] as num?;
    bet.gameRef = data['gameRef'] as DocumentReference;
    await bet._complexAsyncInit();
    return bet;
  }
}
