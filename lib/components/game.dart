import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  String awayname;
  num? awayodds;
  DateTime date;
  num? drawawayodds;
  num? drawhomeodds;
  String homename;
  num? homeodds;
  String? referee;
  num? tieodds;

  Game({
    required this.awayname,
    this.awayodds,
    required this.date,
    this.drawawayodds,
    this.drawhomeodds,
    required this.homename,
    this.homeodds,
    this.referee,
    this.tieodds,
  });

  factory Game.fromMap(Map<String, dynamic> data) {
    print("Game.fromMap called");
    return Game(
      awayname: data['awayname'] as String,
      awayodds: data['awayodds'] as num?,
      date: (data['date'] as Timestamp).toDate(),
      drawawayodds: data['drawawayodds'] as num?,
      drawhomeodds: data['drawhomeodds'] as num?,
      homename: data['homename'] as String,
      homeodds: data['homeodds'] as num?,
      referee: data['referee'] as String?,
      tieodds: data['tieodds'] as num?,
    );
  }
}
