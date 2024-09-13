import 'package:app/models/football_event.dart';

class Duel {
  String? created;
  String? duelID;
  int? entryCost;
  int? gameCount;
  String? hostNickname;
  bool? type;
  List<String>? competitions;
  List<FootballEvent>? games;

  Duel({
      this.created,
      this.duelID,
      this.entryCost,
      this.gameCount,
      this.hostNickname,
      this.type,
      this.competitions,
      this.games,
      });

  Duel.fromJson(Map<String, dynamic> json) {
    created = json['created'] as String;
    duelID = json['duelID'] as String;
    entryCost = json['entryCost'] as int;
    gameCount = json['gameCount'] as int?;
    hostNickname = json['hostNickname'] as String;
    type = json['type'] as bool?;
    
    competitions = <String>[];
    for (final competition in (json['competitionsIncluded'] ?? []) as List<dynamic>) {
      competitions!.add(competition as String);
    }

    games = <FootballEvent>[];
    for (final game in (json['games'] ?? []) as List<dynamic>) {
      games!.add(FootballEvent.fromJson(game as Map<String, dynamic>));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created'] = created;
    data['duelID'] = duelID;
    data['entryCost'] = entryCost;
    data['gameCount'] = gameCount;
    data['hostNickname'] = hostNickname;
    data['type'] = type;
    data['competitionsIncluded'] = competitions;
    return data;
  }
}
