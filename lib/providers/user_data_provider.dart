import 'package:app/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDataProvider extends ChangeNotifier {
  UserData? _userData;

  UserDataProvider() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      requestUserData(user.uid).then((value) => _userData = value);
    }
    // TODO handle no internet connection
  }

  UserData? get userData => _userData;

  set userData(UserData? value) {
    _userData = value;
    notifyListeners();
  }

  Future<UserData?> requestUserData(String uid) async {
    final response = await http
        .get(Uri.parse('https://bet-app-e520a.ew.r.appspot.com/v1/users/$uid'));
    if (response.statusCode == 200) {
      return UserData.fromJson(response.body);
    } else {
      throw Exception('Failed to load user data');
    }

    // return UserData(
    //   displayName: "Test123",
    //   email: "yoooo@gmail.com",
    //   photoURL:
    //       "https://firebasestorage.googleapis.com/v0/b/bet-app-e520a.appspot.com/o/profile_pictures%2Fdefault.jpg?alt=media&token=ab37cd08-4c3e-4da3-9f78-ea5e27f9250d",
    //   emailVerified: true,
    //   uid: "123",
    //   balance: 100,
    //   bgURL:
    //       "https://firebasestorage.googleapis.com/v0/b/bet-app-e520a.appspot.com/o/cosmetics%2Fbackgrounds%2Fdefault.svg?alt=media&token=19c77486-0350-4dba-b4da-d2db07f75df4",
    //   tshirtURL:
    //       "https://firebasestorage.googleapis.com/v0/b/bet-app-e520a.appspot.com/o/cosmetics%2Ftshirts%2Fdefault.svg?alt=media&token=09dd66ff-b5cb-4e61-81c2-9b3423b5ca6a",
    //   frameURL:
    //       "https://firebasestorage.googleapis.com/v0/b/bet-app-e520a.appspot.com/o/cosmetics%2Fframes%2Fdefault.svg?alt=media&token=ce8d5d33-596f-45a8-b9da-b2cdad3692b5",
    // );
  }
}
