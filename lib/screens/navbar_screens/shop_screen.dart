import 'package:app/blocs/league_joining_bloc/league_joining_bloc.dart';
import 'package:app/components/league_screen/join_league_widget.dart';
import 'package:app/components/shop_screen/add_points_widget.dart';
import 'package:app/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late NavigationProvider navigationProvider;

  @override
  void initState() {
    super.initState();
    navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.addListener(resetBlocState);
  }

  @override
  void dispose() {
    navigationProvider.removeListener(resetBlocState);
    super.dispose();
  }

  void resetBlocState() {
    BlocProvider.of<LeagueJoiningBloc>(context).add(CancelLeagueJoinEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text('Random Text'),
              const SizedBox(height: 20),
              JoinLeagueWidget(),
              const AddPointsWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
