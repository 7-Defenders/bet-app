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
      debugPrint('successful call');
      debugPrint(response.body);
      debugPrint(UserData.fromJson(response.body).toString());
      return UserData.fromJson(response.body);
    } else {
      debugPrint('failed to call user data');
      throw Exception('Failed to load user data');
    }
  }
}
