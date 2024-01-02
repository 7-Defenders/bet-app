import 'package:app/components/shop_screen/add_points_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
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
