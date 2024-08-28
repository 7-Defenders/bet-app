import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

enum AchievementType {
  betsWon,
  leaguesJoined,
}

Widget achievement(
  BuildContext context,
  String achievementName,
  AchievementType type,
  num? valueCurrent,
  num valueMax,
  String cosmeticName,
) {
  final bool isAchievementDone =
      valueCurrent != null && valueCurrent >= valueMax;

  return FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const CircularProgressIndicator();
      }

      final prefs = snapshot.data!;
      final bool isRewardCollected =
          prefs.getBool('$achievementName achievement') ?? false;

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            if (type == AchievementType.betsWon)
              Text('Win $valueMax bets')
            else
              Text('Join $valueMax leagues'),
            Text('$valueCurrent/$valueMax'),
            ElevatedButton(
              onPressed: isAchievementDone && !isRewardCollected
                  ? () => giveReward(context, cosmeticName, achievementName)
                  : null,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (!isAchievementDone) {
                      return Colors.grey;
                    } else if (isRewardCollected) {
                      return Colors.yellow[700]!;
                    }
                    return Colors.green;
                  },
                ),
              ),
              child: Text(isRewardCollected ? 'Collected' : 'Collect'),
            ),
          ],
        ),
      );
    },
  );
}

List<Widget> achievementsList(UserData? userData, BuildContext context) {
  return [
    achievement(
      context,
      "Winner",
      AchievementType.betsWon,
      userData?.betsWon ?? 0,
      10,
      "blue boss",
    ),
    achievement(
      context,
      "Explorer",
      AchievementType.leaguesJoined,
      userData?.leaguesJoined ?? 0,
      3,
      "jester",
    ),
  ];
}

Future<void> giveReward(
  BuildContext context,
  String cosmeticName,
  String achievementName,
) async {
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

  final uid =
      Provider.of<UserDataProvider>(context, listen: false).userData?.uid;
  final uri = Uri.encodeFull(
    'https://flask-vhn3gxevdq-ew.a.run.app/v1/users/$uid/cosmetics/$cosmeticName',
  );
  final response = await http.get(Uri.parse(uri));

  if (context.mounted) {
    Navigator.of(context).pop();
  }

  if (context.mounted) {
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$achievementName achievement', true);
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

class _AchievementsScreenState extends State<AchievementsScreen> {
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
          children: achievementsList(userData, context),
        ),
      ),
    );
  }
}
