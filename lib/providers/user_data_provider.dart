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

  void setUserDataOnServerAndLocally(Map<String, String> updateDict) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      http
          .put(
        Uri.parse('https://flask-vhn3gxevdq-ew.a.run.app/v1/users/${user.uid}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: updateDict,
      )
          .then((value) {
        debugPrint('Successfully updated user data');

        // update the local user data based on updateDict
        updateDict.forEach((key, value) {
          switch (key) {
            case 'balance':
              _userData?.balance = double.parse(value);
              notifyListeners();
            case 'bets_won':
              _userData?.betsWon = int.parse(value);
              notifyListeners();
            case 'leagues_joined':
              _userData?.leaguesJoined = int.parse(value);
              notifyListeners();
            case 'emailVerified':
              _userData?.emailVerified = value.toLowerCase() == 'true';
              notifyListeners();
            default:
              _userData?.setValue(key, value);
              notifyListeners();
              break;
          }
        });

        notifyListeners();
        // ignore: invalid_return_type_for_catch_error
      }).catchError((error) => debugPrint('Failed to update user data'));
    }
  }

  void updateSingleField(String field, String value) {
    switch (field) {
      case 'balance':
        _userData?.balance = double.parse(value);
        notifyListeners();
      case 'bets_won':
        _userData?.betsWon = int.parse(value);
        notifyListeners();
      case 'leagues_joined':
        _userData?.leaguesJoined = int.parse(value);
        notifyListeners();
      case 'emailVerified':
        _userData?.emailVerified = value.toLowerCase() == 'true';
        notifyListeners();
      default:
        _userData?.setValue(field, value);
        notifyListeners();
        break;
    }
  }

  void getCoins(int value) {
    _userData?.balance = _userData!.balance + value;
    notifyListeners();
  }

  void spendCoins(int value) {
    _userData?.balance = _userData!.balance - value;
    notifyListeners();
  }

  num getBalance() {
    return _userData!.balance;
  }

  Future<UserData?> requestUserData(String uid) async {
    final response = await http
        .get(Uri.parse('https://flask-vhn3gxevdq-ew.a.run.app/v1/users/$uid'));
    if (response.statusCode == 200) {
      return UserData.fromJson(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void awardCoins(num amount) {}
}
