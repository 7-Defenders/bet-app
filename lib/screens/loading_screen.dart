import 'package:app/providers/user_data_provider.dart';
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

    debugPrint('user: $user');
    debugPrint("i will wait 5 seconds now!");
    // wait 5 seconds before fetching the user data so that it's saved in DB
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      if (user != null) {
        // wait for API call to request user data and then manually set it
        debugPrint("wait is over. lets fetch data!");
        await Provider.of<UserDataProvider>(context, listen: false)
            .requestUserData(FirebaseAuth.instance.currentUser!.uid)
            .then(
              (value) => Provider.of<UserDataProvider>(context, listen: false)
                  .userData = value,
            );
      }
      debugPrint("data fetching ended!");
      debugPrint(
        "ofter the data fetching user data is: ${Provider.of<UserDataProvider>(context, listen: false).userData}",
      );
      if (Provider.of<UserDataProvider>(context, listen: false).userData !=
          null) {
        GoRouter.of(context).go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occured - please log in again.'),
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
