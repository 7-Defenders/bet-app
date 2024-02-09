import 'package:app/components/other/appbar/balance_widget.dart';
import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  void goHome(BuildContext context) {
    GoRouter.of(context).go('/home');
  }

  IconButton buildBackButton(double vw, double vh) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        goHome(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: move all vw and vh calculations to constants file or find a better way to handle them
    final double vw = MediaQuery.of(context).size.width / 100;
    final double vh = MediaQuery.of(context).size.height / 100;

    return Scaffold(
      appBar: CustomAppbar(
        56,
        buildBackButton(vw, vh),
        'Home2',
        [
          Padding(
            padding: EdgeInsets.only(right: vw * 3),
            child: BalanceWidget(vw: vw, vh: vh),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Screen 2'),
      ),
    );
  }
}
