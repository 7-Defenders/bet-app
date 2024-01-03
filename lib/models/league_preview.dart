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
  String leagueID;
  int playerCount;
  int rank;

  LeaguePreviewModel({
    required this.leagueName,
    required this.leagueID,
    required this.playerCount,
    required this.rank,
  });

  factory LeaguePreviewModel.fromJson(Map<String, dynamic> json) => LeaguePreviewModel(
        leagueName: json["leagueName"] as String,
        leagueID: json["leagueID"] as String,
        playerCount: json["playerCount"] as int,
        rank: json["rank"] as int,
      );

  Map<String, dynamic> toJson() => {
        "leagueName": leagueName,
        "leagueID": leagueID,
        "playerCount": playerCount,
        "rank": rank,
      };
}
