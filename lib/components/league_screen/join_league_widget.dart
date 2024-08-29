import 'dart:convert';

import 'package:app/components/other/nunito_text.dart';
import 'package:app/globals.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class JoinLeagueWidget extends StatefulWidget {
  Function() onJoined;

  JoinLeagueWidget(this.onJoined,{super.key});

  @override
  State<JoinLeagueWidget> createState() => _JoinLeagueWidgetState();
}

Future<void> joinLeague(String leagueCode, String userID, Function() onJoined) async {
  debugPrint("joining league with code $leagueCode and userID $userID");
  final response = await http.post(
    Uri.parse('https://flask-vhn3gxevdq-ew.a.run.app/v1/leagues/join'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'leagueCode': leagueCode,
      'userID': userID,
    }),
  );

  debugPrint("STATUS CODE IS ${response.statusCode}");

  if ((response.statusCode / 100).floor() == 2) {
    debugPrint('Successfully joined the league');
    Globals.joinedNewLeague = true;
    await onJoined();
  } else {
    debugPrint('Failed to join league: ${response.body}');
    throw Exception('Failed to join league: ${response.body}');
  }
}

void showLeagueCodeInputDialog(BuildContext context, Function() onJoined) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController leagueCodeController = TextEditingController();
  final focusNode = FocusNode();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Input League Code'),
        content: Form(
          key: formKey,
          child: TextFormField(
            focusNode: focusNode,
            controller: leagueCodeController,
            validator: (value) {
              if (value == null || value.length != 6) {
                return 'Please enter a 6 character league code';
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: nunitoText("Join League", 16, FontWeight.normal, Colors.black),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final uid = FirebaseAuth.instance.currentUser!.uid;
                onJoinButtonClicked(context, leagueCodeController.text, uid, onJoined);
                focusNode.unfocus();
              }
            },
          ),
        ],
      );
    },
  );
}

void onJoinButtonClicked(
    BuildContext context, String leagueCode, String userID, Function() onJoined,) {
  joinLeague(leagueCode, userID, onJoined).then((_) {
    FocusManager.instance.primaryFocus?.unfocus();

    Provider.of<UserDataProvider>(context, listen: false)
        .requestUserData(FirebaseAuth.instance.currentUser!.uid)
        .then((UserData? newData) {
      Provider.of<UserDataProvider>(context, listen: false).userData = newData;
    }).then((_) {
      Navigator.of(context).pop(); // pop the loading dialog
    });

    debugPrint('Successfully joined the league');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Successfully joined the league')),
    // );
  }).catchError((error) {
    debugPrint(error.toString());
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Failed to join league: $error')),
    // );
  });
}

class _JoinLeagueWidgetState extends State<JoinLeagueWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
      ),
      onPressed: () {
        showLeagueCodeInputDialog(context, widget.onJoined);
      },
      child: nunitoText("Join a league", 16, FontWeight.normal, Colors.white),
    );
  }
}
