import 'package:app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AchievementType {
  betsWon,
  leaguesJoined,
}

class Achievement {
  final String id;
  final String name;
  final num currentAmount;
  final num amountNeeded;
  final bool isCompleted;
  final num? rewardPoints;
  final String? rewardCosmetic;
  final AchievementType achievementType;

  Achievement({
    required this.id,
    required this.name,
    required this.currentAmount,
    required this.isCompleted,
    required this.amountNeeded,
    this.rewardPoints,
    this.rewardCosmetic,
    required this.achievementType,
  });

  Future<void> giveReward(
    BuildContext context,
    AchievementType type,
    String? awardCosmeticRef,
    num? awardPoints,
  ) async {
    final uid =
        Provider.of<UserDataProvider>(context, listen: false).userData?.uid;
    final uri = Uri.encodeFull(
      'https://flask-vhn3gxevdq-ew.a.run.app/v1/users/$uid/cosmetics/$cosmeticName',
    );
    final response = await http.post(Uri.parse(uri));

    if (context.mounted) {
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('${achievement.name} achievement', true);
        // setState(() {
        //   isRewardCollected = true;
        // });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You recievsed a new cosmetic: $cosmeticName!"),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to give reward"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
