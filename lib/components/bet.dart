import 'package:app/components/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bet {
  late num amount;
  late num bet;
  late num betOdds;
  late num? result;
  late DocumentReference gameRef;
  late Game game;

  Bet._();

  Future<void> _complexAsyncInit() async {
    print("Bet._complexAsyncInit called");
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
  static Future<Bet> create(Map<String, dynamic> data) async {
    print("Bet public factory");
    final bet = Bet._();
    bet.amount = data['amount'] as num;
    bet.bet = data['bet'] as num;
    bet.betOdds = data['betodds'] as num;
    bet.result = data['result'] as num?;
    bet.gameRef = data['gameRef'] as DocumentReference;
    await bet._complexAsyncInit();
    return bet;
  }
}
