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
      );

  static UserData? fromJson(String jsonString) {
    try {
      final Map<String, dynamic> userDataMap =
          jsonDecode(jsonString) as Map<String, dynamic>;

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
      );
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static UserData? fromMap(Map<String, dynamic> userDataMap) {
    try {
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
      );
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }
}
