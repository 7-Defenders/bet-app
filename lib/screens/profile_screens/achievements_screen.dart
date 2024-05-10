import 'dart:convert';

import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/globals.dart';
import 'package:app/models/achievement.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<Achievement> achievementList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAchievements();
    });
  }

  Future<void> fetchAchievements() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: Theme.of(context).colorScheme.primary,
            size: 55,
          ),
        );
      },
      barrierDismissible: false,
      useRootNavigator: false,
    );

    final num
        currentUserLeaguesJoined = //TODO: get from firebase, since user can be kicked and the userData will remain same
        Provider.of<UserDataProvider>(context, listen: false)
                .userData
                ?.leaguesJoined ??
            0;

    final num currentUserBetsWon =
        Provider.of<UserDataProvider>(context, listen: false)
                .userData
                ?.betsWon ??
            0;

    final uid =
        Provider.of<UserDataProvider>(context, listen: false).userData?.uid;
    final uri =
        'https://flask-vhn3gxevdq-ew.a.run.app/v1/users/$uid/achievements';
    const uri2 = 'https://flask-vhn3gxevdq-ew.a.run.app/v1/achievements';
    final userAchievementsResponse = await http.get(Uri.parse(uri));
    final allAchievementsResponse = await http.get(Uri.parse(uri2));

    final Map<String, dynamic> userAchievementsJson =
        jsonDecode(userAchievementsResponse.body) as Map<String, dynamic>;
    final List userAchievementsData =
        userAchievementsJson['achievements'] as List;

    final Map<String, dynamic> allAchievementsJson =
        jsonDecode(allAchievementsResponse.body) as Map<String, dynamic>;
    final List<Map<String, dynamic>> allAchievementsData =
        allAchievementsJson['achievements'] as List<Map<String, dynamic>>;

    final List<Achievement> achievements = [];

    for (final Map<String, dynamic> achievementData in allAchievementsData) {
      final id = achievementData['id'] as String;
      final name = achievementData['name'] as String;
      final currentAmount = achievementData['achievementType'] == 'bets_won'
          ? currentUserBetsWon
          : currentUserLeaguesJoined;
      final isCompleted = userAchievementsData
          .where((element) => element['id'] == id)
          .isNotEmpty;
      final amountNeeded = achievementData['amountNeeded'] as num;
      final rewardPoints = achievementData['rewardPoints'] as num?;
      final rewardCosmetic = achievementData['rewardCosmetic'] as String?;
      final achievementType = achievementData['achievementType'] == 'bets_won'
          ? AchievementType.betsWon
          : AchievementType.leaguesJoined;

      final Achievement achievement = Achievement(
        id: id,
        name: name,
        currentAmount: currentAmount,
        isCompleted: isCompleted,
        amountNeeded: amountNeeded,
        rewardPoints: rewardPoints,
        rewardCosmetic: rewardCosmetic,
        achievementType: achievementType,
      );

      achievements.add(achievement);
    }
    achievementList = achievements;
  }

  @override
  Widget build(BuildContext context) {
    final UserData? userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;

    return Scaffold(
      appBar: CustomAppbar(
        56,
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        'Achievements',
        null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getAchievementsList(achievementList),
        ),
      ),
    );
  }
}

List<Widget> getAchievementsList(List<Achievement> achievementList) {
  final List<Achievement> completedAchievements =
      achievementList.where((widget) => widget.isCompleted == true).toList();

  final List<Achievement> uncompletedAchievements =
      achievementList.where((widget) => widget.isCompleted == true).toList();

  return [
    const SizedBox(height: 40),
    Padding(
      padding: const EdgeInsets.only(left: 20),
      child: nunitoText(
        'Uncompleted',
        20,
        FontWeight.bold,
        const Color.fromARGB(255, 30, 30, 27),
      ),
    ),
    GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: uncompletedAchievements,
    ),
    Padding(
      padding: const EdgeInsets.only(left: 20),
      child: nunitoText(
        'Completed',
        20,
        FontWeight.bold,
        const Color.fromARGB(255, 30, 30, 27),
      ),
    ),
    GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: completedAchievements,
    ),
  ];
}
