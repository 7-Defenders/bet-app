// To parse this JSON data, do
//
//     final footballEvent = footballEventFromJson(jsonString);

import 'dart:convert';

List<FootballEvent> footballEventFromJson(String str) {
  final jsonData = json.decode(str);
  final List<FootballEvent> data = [];

  for (final item in jsonData as List) {
    data.add(FootballEvent.fromJson(item as Map<String, dynamic>));
  }

  return data;
}

class FootballEvent {
  String awayname;
  double awayodds;
  // String competition;
  String date;
  double drawawayodds;
  double homedrawodds;
  String homename;
  double homeodds;
  String? referee;
  double tieodds;
  String matchRef;
  double homedrawodds;
  double drawawayodds;

  FootballEvent({
    required this.awayname,
    required this.awayodds,
    // required this.competition,
    required this.date,
    required this.drawawayodds,
    required this.homedrawodds,
    required this.homename,
    required this.homeodds,
    required this.referee,
    required this.tieodds,
    required this.matchRef,
    required this.homedrawodds,
    required this.drawawayodds,
  });

  factory FootballEvent.fromJson(Map<String, dynamic> json) => FootballEvent(
        awayname: json["awayname"] as String,
        awayodds: double.parse(json["awayodds"].toString()),
        // competition: json["competition"]  as String,
        date: json["date"] as String,
        drawawayodds: double.parse(json["drawawayodds"].toString()),
        homedrawodds: double.parse(json["homedrawodds"].toString()),
        homename: json["homename"] as String,
        homeodds: double.parse(json["homeodds"].toString()),
        referee: json["referee"] as String?,
        tieodds: double.parse(json["tieodds"].toString()),
        matchRef: json["matchRef"] as String,
        homedrawodds: double.parse(json["homedrawodds"].toString()),
        drawawayodds: double.parse(json["drawawayodds"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "awayname": awayname,
        "awayodds": awayodds,
        // "competition": competition,
        "date": date,
        "drawawayodds": drawawayodds,
        "homedrawodds": homedrawodds,
        "homename": homename,
        "homeodds": homeodds,
        "referee": referee,
        "tieodds": tieodds,
        "matchRef": matchRef,
        "homedrawodds": homedrawodds,
        "drawayodds": drawawayodds,
      };
}
