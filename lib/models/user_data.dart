import 'dart:convert';
import 'package:flutter/material.dart';

class UserData {
  String? displayName;
  String? email;
  String? photoURL;
  bool emailVerified;
  String uid;
  num balance;

  UserData({
    this.displayName,
    required this.email,
    this.photoURL,
    required this.emailVerified,
    required this.uid,
    required this.balance,
  });

  UserData get userData => UserData(
        displayName: displayName,
        email: email,
        photoURL: photoURL,
        emailVerified: emailVerified,
        uid: uid,
        balance: balance,
      );

  set userData(UserData userData) => UserData(
        displayName: userData.displayName,
        email: userData.email,
        photoURL: userData.photoURL,
        emailVerified: userData.emailVerified,
        uid: userData.uid,
        balance: userData.balance,
      );

  static UserData? fromJson(String jsonString) {
    try {
      final Map<String, dynamic> userDataMap =
          jsonDecode(jsonString) as Map<String, dynamic>;

      return UserData(
        displayName: userDataMap['displayName'] as String,
        email: userDataMap['email'] as String,
        photoURL: userDataMap['photoURL'] as String?,
        emailVerified: userDataMap['emailVerified'] as bool? ?? false,
        uid: userDataMap['uid'] as String,
        balance: userDataMap['balance'] as num? ?? 0, //TODO if works remove '?'
      );
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }
}
