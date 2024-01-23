import 'dart:convert';

class Bet {
  int? amount;
  String? bet;
  double? betodds;
  Game? game;
  String? madeAt;
  int? result;

  Bet(
      {this.amount,
      this.bet,
      this.betodds,
      this.game,
      this.madeAt,
      this.result});

  Bet.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] as int?;
    bet = json['bet'] as String?;
    betodds = json['betodds'] as double?;
    game = json['game'] != null
        ? Game.fromJson(json['game'] as Map<String, dynamic>)
        : null;
    madeAt = json['madeAt'] as String?;
    result = json['result'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['bet'] = bet;
    data['betodds'] = betodds;
    if (game != null) {
      data['game'] = game!.toJson();
    }
    data['madeAt'] = madeAt;
    data['result'] = result;
    return data;
  }
}

class Game {
  String? awayname;
  double? awayodds;
  String? date;
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
      this.tieodds});

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        awayname: json["awayname"] as String,
        awayodds: json["awayodds"] != null
            ? double.parse(json["awayodds"].toString())
            : null,
        // competition: json["competition"]  as String,
        date: json["date"] as String,
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
        "date": date,
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
