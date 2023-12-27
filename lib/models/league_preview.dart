// To parse this JSON data, do
//
//     final footballEvent = footballEventFromJson(jsonString);

import 'dart:convert';

List<LeaguePreviewModel> leaguePreviewFromJson(String str) {
  final jsonData = json.decode(str);
  final List<LeaguePreviewModel> data = [];

  for (final item in jsonData as List) {
    data.add(LeaguePreviewModel.fromJson(item as Map<String, dynamic>));
  }

  return data;
}

class LeaguePreviewModel {
  String leagueName;
  int playerCount;
  int rank;

  LeaguePreviewModel({
    required this.leagueName,
    required this.playerCount,
    // required this.competition,
    required this.rank,
  });

  factory LeaguePreviewModel.fromJson(Map<String, dynamic> json) => LeaguePreviewModel(
        leagueName: json["leagueName"] as String,
        playerCount: json["playerCount"] as int,
        // competition: json["competition"]  as String,
        rank: json["rank"] as int,
      );

  Map<String, dynamic> toJson() => {
        "leagueName": leagueName,
        "playerCount": playerCount,
        "rank": rank,
      };
}
