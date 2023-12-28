import 'dart:convert';

import 'package:app/models/structure.dart';

class LeagueSummaryModel{
  int? entryCost;
  String? leagueCode;
  String? leagueName;
  int? playerCount;
  List<PlayerSummaryModel>? users;

  LeagueSummaryModel(
      {this.entryCost,
      this.leagueCode,
      this.leagueName,
      this.playerCount,
      this.users,});

  LeagueSummaryModel.fromJson(Map<String, dynamic> json) {
    entryCost = json['entryCost'] as int;
    leagueCode = json['leagueCode'] as String;
    leagueName = json['leagueName'] as String;
    playerCount = json['playerCount'] as int;
    if (json['users'] != null) {
      users = playerSummaryFromJson(jsonEncode(json['users']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entryCost'] = entryCost;
    data['leagueCode'] = leagueCode;
    data['leagueName'] = leagueName;
    data['playerCount'] = playerCount;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<PlayerSummaryModel> playerSummaryFromJson(String str) {
    final jsonData = json.decode(str);
    final List<PlayerSummaryModel> data = [];

    for (final item in jsonData as List) {
      data.add(PlayerSummaryModel.fromJson(item as Map<String, dynamic>));
    }

    data.sort((a, b) => b.points!.compareTo(a.points!));

    return data;
  }
}

class PlayerSummaryModel {
  int? points;
  String? username;

  PlayerSummaryModel({this.points, this.username});

  PlayerSummaryModel.fromJson(Map<String, dynamic> json) {
    points = int.parse(json['points'].toString());
    username = json['username'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['points'] = points;
    data['username'] = username;
    return data;
  }
}

LeagueSummaryModel leagueSummaryFromJson(String str) =>
    LeagueSummaryModel.fromJson(json.decode(str) as Map<String, dynamic>);
