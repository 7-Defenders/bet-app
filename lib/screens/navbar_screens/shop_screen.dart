import 'package:app/components/other/appbar/balance_widget.dart';
import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/components/shop_screen/add_points_widget.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    //TODO: move all vw and vh calculations to constants file or find a better way to handle them
    final double vw = MediaQuery.of(context).size.width / 100;
    final double vh = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      appBar: CustomAppbar(
        56,
        null,
        'Shop',
        [
          Padding(
            padding: EdgeInsets.only(right: vw * 3),
            child: BalanceWidget(vw: vw, vh: vh),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text('Random Text'),
                  SizedBox(height: 20),
                  AddPointsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
