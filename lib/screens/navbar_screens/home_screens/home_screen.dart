import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void goHome2(BuildContext context) {
    GoRouter.of(context).go('/home/2');
  }

  Future<void> logOutUser() async {
    Provider.of<UserDataProvider>(context, listen: false).userData = null;
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        56,
        null,
        'Home',
        null,
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Home Screen'),
            ElevatedButton(
              onPressed: () {
                goHome2(context);
              },
              child: const Text('Go to Home 2'),
            ),
            ElevatedButton(
              onPressed: () {
                logOutUser();
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
