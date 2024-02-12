import 'package:app/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  UserData? _userData;

  UserDataProvider() {
    fetchUserData().then((UserData? userData) {
      updateUserData(userData);
    });
  }

  UserData? get userData => _userData;

  void updateUserData(UserData? newData) {
    _userData = newData;
    notifyListeners();
  }

  Future<UserData?> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String? displayName = user.displayName;
      final String? email = user.email;
      final String? photoURL = user.photoURL;

      return UserData(
        displayName: displayName,
        email: email,
        photoURL: photoURL,
        emailVerified: user.emailVerified,
        uid: user.uid,
      );
    }
    return null;
  }
}
