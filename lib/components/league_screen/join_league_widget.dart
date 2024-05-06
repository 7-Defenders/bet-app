import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JoinLeagueWidget extends StatefulWidget {
  const JoinLeagueWidget({super.key});

  @override
  State<JoinLeagueWidget> createState() => _JoinLeagueWidgetState();
}

Future<void> joinLeague(String leagueCode, String userID) async {
  print("joining league with code $leagueCode and userID $userID");
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

  print("STATUS CODE IS ${response.statusCode}");

  if ((response.statusCode / 100).floor() == 2) {
    print('Successfully joined the league');
  } else {
    print('Failed to join league: ${response.body}');
    throw Exception('Failed to join league: ${response.body}');
  }
}

void showLeagueCodeInputDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController leagueCodeController = TextEditingController();
  final focusNode = FocusNode();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Input League Code'),
        content: Form(
          key: _formKey,
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
            child: const Text('Join League'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final uid = FirebaseAuth.instance.currentUser!.uid;
                onJoinButtonClicked(context, leagueCodeController.text, uid);
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
    BuildContext context, String leagueCode, String userID) {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    barrierDismissible: false,
  );

  joinLeague(leagueCode, userID).then((_) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
    print('Successfully joined the league');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Successfully joined the league')),
    // );
  }).catchError((error) {
    print(error);
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
      onPressed: () {
        showLeagueCodeInputDialog(context);
      },
      child: const Text('Join League'),
    );
  }
}
