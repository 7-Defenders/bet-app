import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // topBar(context,
        //  'lib/assets/images/Settings.svg',
        //  () {
        //   //TODO navigate to settings screen
        //  },
        // ),
        Expanded(
          child: Center(
              child: Text(
                'Shop goes here',
                style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
                ),
          ),
        ),
      ],
    );
  }
}
