// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:app/models/duel.dart';

class Invites {
  List<Duel>? duels;

  Invites({this.duels});

  Invites.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json) as Map<String, dynamic>;
    duels = <Duel>[];
    data['duels'].forEach((v) {
      duels!.add(Duel.fromJson(v as Map<String, dynamic>));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (duels != null) {
      data['duels'] = duels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
