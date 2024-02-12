import 'dart:convert';
import 'package:intl/intl.dart';

final DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");

class Bet {
  int? amount;
  String? bet;
  double? betodds;
  String? competition;
  Game? game;
  DateTime? madeAt;
  int? result;
  String? sport;

  Bet(
      {this.amount,
      this.bet,
      this.betodds,
      this.competition,
      this.game,
      this.madeAt,
      this.result,
      this.sport,});

  Bet.fromJson(Map<String, dynamic> json) {

    amount = json['amount'] as int?;
    bet = json['bet'] as String?;
    betodds = json['betodds'] as double?;
    competition = json["competition"] as String?;
    game = json['game'] != null
        ? Game.fromJson(json['game'] as Map<String, dynamic>)
        : null;
    madeAt = json['madeAt'] == null ? DateTime(2000,) : dateFormat.parse(json['madeAt'] as String);
    result = json['result'] as int?;
    sport = json["sport"] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['bet'] = bet;
    data['betodds'] = betodds;
    data['competition'] = competition;
    if (game != null) {
      data['game'] = game!.toJson();
    }
    data['madeAt'] = madeAt.toString();
    data['result'] = result;
    data['sport'] = sport;
    return data;
  }
}

class Game {
  String? awayname;
  double? awayodds;
  DateTime? date;
  double? drawawayodds;
  double? homedrawodds;
  String? homename;
  double? homeodds;
  String? referee;
  double? tieodds;

  Game(
      {this.awayname,
      this.awayodds,
      this.date,
      this.drawawayodds,
      this.homedrawodds,
      this.homename,
      this.homeodds,
      this.referee,
      this.tieodds,});

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        awayname: json["awayname"] as String,
        awayodds: json["awayodds"] != null
            ? double.parse(json["awayodds"].toString())
            : null,
        date: json['date'] == null ? DateTime(2000,) : dateFormat.parse(json['date'] as String),
        drawawayodds: json["drawawayodds"] != null
            ? double.parse(json["drawawayodds"].toString())
            : null,
        homedrawodds: json["homedrawodds"] != null
            ? double.parse(json["homedrawodds"].toString())
            : null,
        homename: json["homename"] as String,
        homeodds: json["homeodds"] != null
            ? double.parse(json["homeodds"].toString())
            : null,
        referee: json["referee"] as String?,
        tieodds: json["tieodds"] != null
            ? double.parse(json["tieodds"].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        "awayname": awayname,
        "awayodds": awayodds,
        "date": date.toString(),
        "drawawayodds": drawawayodds,
        "homedrawodds": homedrawodds,
        "homename": homename,
        "homeodds": homeodds,
        "referee": referee,
        "tieodds": tieodds,
      };
}

List<Bet> betFromJson(String str) {
  final jsonData = json.decode(str);
  final List<Bet> data = [];

  for (final item in jsonData as List) {
    data.add(Bet.fromJson(item as Map<String, dynamic>));
  }

  return data;
}
