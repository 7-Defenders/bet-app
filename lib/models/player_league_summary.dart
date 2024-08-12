import 'dart:convert';

class LeagueSummaryModel {
  int? entryCost;
  String? leagueCode;
  String? leagueName;
  int? playerCount;
  List<PlayerSummaryModel>? users;
  List<String>? competitionsIncluded;
  bool? private;
  // String? adminID;

  LeagueSummaryModel({
    this.entryCost,
    this.leagueCode,
    this.leagueName,
    this.playerCount,
    this.users,
    this.competitionsIncluded,
    this.private,
    // this.adminID,
  });

  LeagueSummaryModel.fromJson(Map<String, dynamic> json) {
    entryCost = json['entryCost'] as int;
    leagueCode = json['leagueCode'] as String;
    leagueName = json['leagueName'] as String;
    playerCount = json['playerCount'] as int;
    private = json['private'] as bool?;
    if (json['users'] != null) {
      users = playerSummaryFromJson(jsonEncode(json['users']));
    }
    // adminID = json['admin_id'] as String;

    competitionsIncluded = [];
    for (final elem in json['competitionsIncluded'] as List) {
      competitionsIncluded!.add(elem['competitionRef'].toString());
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
  String? userID;

  PlayerSummaryModel({this.points, this.username, this.userID});

  PlayerSummaryModel.fromJson(Map<String, dynamic> json) {
    points = int.parse(json['points'].toString());
    username = json['username'].toString();
    userID = json['userID'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['points'] = points;
    data['username'] = username;
    data['userID'] = userID;
    return data;
  }
}

LeagueSummaryModel leagueSummaryFromJson(String str) =>
    LeagueSummaryModel.fromJson(json.decode(str) as Map<String, dynamic>);
