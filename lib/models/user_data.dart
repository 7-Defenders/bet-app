import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserData {
  String? displayName;
  String? email;
  String? photoURL;
  bool emailVerified;
  String uid;
  num balance;
  String? bgURL;
  String? frameURL;
  String? tshirtURL;
  num betsWon;
  num leaguesJoined;

  UserData({
    this.displayName,
    required this.email,
    this.photoURL,
    required this.emailVerified,
    required this.uid,
    required this.balance,
    required this.bgURL,
    required this.frameURL,
    required this.tshirtURL,
    required this.betsWon,
    required this.leaguesJoined,
  });

  UserData get userData => UserData(
        displayName: displayName,
        email: email,
        photoURL: photoURL,
        emailVerified: emailVerified,
        uid: uid,
        balance: balance,
        bgURL: bgURL,
        frameURL: frameURL,
        tshirtURL: tshirtURL,
        betsWon: betsWon,
        leaguesJoined: leaguesJoined,
      );

  set userData(UserData userData) => UserData(
        displayName: userData.displayName,
        email: userData.email,
        photoURL: userData.photoURL,
        emailVerified: userData.emailVerified,
        uid: userData.uid,
        balance: userData.balance,
        bgURL: userData.bgURL,
        frameURL: userData.frameURL,
        tshirtURL: userData.tshirtURL,
        betsWon: userData.betsWon,
        leaguesJoined: userData.leaguesJoined,
      );

  void setValue(String key, dynamic value) {
    switch (key) {
      case 'displayName':
        displayName = value as String;
        break;
      case 'email':
        email = value as String;
        break;
      case 'photoURL':
        photoURL = value as String;
        break;
      case 'emailVerified':
        emailVerified = value as bool;
        break;
      case 'uid':
        uid = value as String;
        break;
      case 'balance':
        balance = value as num;
        break;
      case 'bgURL':
        bgURL = value as String;
        break;
      case 'frameURL':
        frameURL = value as String;
        break;
      case 'tshirtURL':
        tshirtURL = value as String;
        break;
      case 'betsWon':
        betsWon = value as num;
        break;
      case 'leaguesJoined':
        leaguesJoined = value as num;
        break;
      default:
        debugPrint('Invalid key: $key');
        break;
    }
  }

  static UserData? fromJson(String jsonString) {
    try {
      final Map<String, dynamic> userDataMap =
          jsonDecode(jsonString) as Map<String, dynamic>;

      print(userDataMap);

      return UserData(
        displayName: userDataMap['displayName'] as String,
        email: userDataMap['email'] as String,
        photoURL: userDataMap['photoURL'] as String? ??
            dotenv.env['DEFAULT_PFP_URL']!,
        emailVerified: userDataMap['emailVerified'] as bool? ?? false,
        uid: userDataMap['uid'] as String,
        balance: userDataMap['balance'] as num,
        bgURL: userDataMap['bgURL'] as String? ?? dotenv.env['DEFAULT_BG_URL']!,
        frameURL: userDataMap['frameURL'] as String? ??
            dotenv.env['DEFAULT_FRAME_URL']!,
        tshirtURL: userDataMap['tshirtURL'] as String? ??
            dotenv.env['DEFAULT_TSHIRT_URL']!,
        betsWon: userDataMap['bets_won'] as num,
        leaguesJoined: userDataMap['leagues_joined'] as num,
      );
    } catch (e) {
      debugPrint('Error: $e FILE USERDATA LIKE 84');
      return null;
    }
  }

  static UserData? fromMap(Map<String, dynamic> userDataMap) {
    try {
      // print user data
      print(userDataMap);
      return UserData(
        displayName: userDataMap['displayName'] as String,
        email: userDataMap['email'] as String,
        photoURL: userDataMap['photoURL'] as String? ??
            dotenv.env['DEFAULT_PFP_URL']!,
        emailVerified: userDataMap['emailVerified'] as bool? ?? false,
        uid: userDataMap['uid'] as String,
        balance: userDataMap['balance'] as num,
        bgURL: userDataMap['bgURL'] as String? ?? dotenv.env['DEFAULT_BG_URL']!,
        frameURL: userDataMap['frameURL'] as String? ??
            dotenv.env['DEFAULT_FRAME_URL']!,
        tshirtURL: userDataMap['tshirtURL'] as String? ??
            dotenv.env['DEFAULT_TSHIRT_URL']!,
        betsWon: userDataMap['bets_won'] as num,
        leaguesJoined: userDataMap['leagues_joined'] as num,
      );
    } catch (e) {
      debugPrint('Error: $e FILE USERDATA LINE 110');
      return null;
    }
  }
}
