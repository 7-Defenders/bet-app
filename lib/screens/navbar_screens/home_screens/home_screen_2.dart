import 'package:app/components/other/appbar/balance_widget.dart';
import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  IconButton buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        GoRouter.of(context).go('/home');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: move all vw and vh calculations to constants file or find a better way to handle them
    final double vw = MediaQuery.of(context).size.width / 100;

    return Scaffold(
      appBar: CustomAppbar(
        56,
        buildBackButton(),
        'Home2',
        [
          Padding(
            padding: EdgeInsets.only(right: vw * 3),
            child: Consumer<UserDataProvider>(
              builder: (context, userDataProvider, child) {
                return BalanceWidget(
                  bgColor: const Color.fromARGB(255, 255, 163, 21),
                  //get balance from userdataprovider
                  balance: userDataProvider.userData!.balance.toInt(),
                );
              },
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Screen 2'),
      ),
    );
  }
}
