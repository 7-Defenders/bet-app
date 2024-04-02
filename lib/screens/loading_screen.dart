import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        try {
          asyncLoadData();
        } catch (e) {
          debugPrint('Error in asyncLoadData: $e');
        }
      },
    );
  }

  Future<void> asyncLoadData() async {
    final user = FirebaseAuth.instance.currentUser;
    // await Future.delayed(const Duration(seconds: 5)); //TODO transaction
    if (mounted) {
      if (user != null) {
        final userDataProvider =
            Provider.of<UserDataProvider>(context, listen: false);
        final Map<String, dynamic> userData = await FirebaseFirestore.instance
            .runTransaction<Map<String, dynamic>>((transaction) async {
          final userDataSnapshot = await transaction.get(
            FirebaseFirestore.instance.collection('users').doc(user.uid),
          );
          return Future.value(userDataSnapshot.data());
        });
        final UserData? ud = UserData.fromMap(userData);
        userDataProvider.userData = ud;
      }
      // if (user != null) {
      //   // wait for API call to request user data and then manually set it
      //   debugPrint("wait is over. lets fetch data!");
      //   await Provider.of<UserDataProvider>(context, listen: false)
      //       .requestUserData(FirebaseAuth.instance.currentUser!.uid)
      //       .then(
      //         (value) => Provider.of<UserDataProvider>(context, listen: false)
      //             .userData = value,
      //       );
      // }
      if (Provider.of<UserDataProvider>(context, listen: false).userData !=
          null) {
        GoRouter.of(context).go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred - please log in again.'),
          ),
        );
        GoRouter.of(context).go('/auth');
      }
    } else {
      throw Exception('LoadingScreen is not mounted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
