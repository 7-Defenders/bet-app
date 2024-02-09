import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void goHome2(BuildContext context) {
    GoRouter.of(context).go('/home/2');
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
          ],
        ),
      ),
    );
  }
}
