import 'package:app/blocs/league_joining_bloc/league_joining_bloc.dart';
import 'package:app/components/league_screen/join_league_widget.dart';
import 'package:app/components/shop_screen/add_points_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopScreen extends StatefulWidget {
  ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text('Random Text'),
              SizedBox(height: 20),
              // JoinLeagueWidget(),
              AddPointsWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
