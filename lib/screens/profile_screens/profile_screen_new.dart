import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreenNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context).userData;

    Future<void> logOutUser() async {
      Provider.of<UserDataProvider>(context, listen: false)
          .updateUserData(null);
      await FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: (userData != null)
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Display Name: ${userData.displayName ?? 'N/A'}'),
                  Text('Email: ${userData.email ?? 'N/A'}'),
                  Text('Photo URL: ${userData.photoURL ?? 'N/A'}'),
                  Text(
                    'Email Verified: ${userData.emailVerified ? 'Yes' : 'No'}',
                  ),
                  Text('UID: ${userData.uid}'),
                  ElevatedButton(
                    onPressed: logOutUser,
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
