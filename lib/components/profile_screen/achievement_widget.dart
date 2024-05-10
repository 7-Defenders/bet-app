import 'package:app/components/other/nunito_text.dart';
import 'package:app/models/achievement.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AchievementWidget extends StatefulWidget {
  final Achievement achievement;

  const AchievementWidget({
    required this.achievement,
    super.key,
  });

  @override
  _AchievementWidgetState createState() => _AchievementWidgetState();
}

class _AchievementWidgetState extends State<AchievementWidget> {
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
        await prefs.setBool('$achievementName achievement', true);
        setState(() {
          isRewardCollected = true;
        });
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

  @override
  Widget build(BuildContext context) {
    final bool isAchievementDone = widget.achievement.isCompleted;

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final prefs = snapshot.data!;
        isRewardCollected =
            prefs.getBool('${widget.achievementName} achievement') ?? false;

        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: !isRewardCollected
                    ? () => giveReward(
                          context,
                          widget.cosmeticName,
                          widget.achievementName,
                        )
                    : null,
                child: CircularPercentIndicator(
                  radius: constraints.maxWidth * 0.36,
                  animation: true,
                  animationDuration: 1200,
                  lineWidth: 15.0,
                  percent: (widget.valueCurrent! / widget.valueMax) > 1
                      ? 1
                      : (widget.valueCurrent! / widget.valueMax),
                  backgroundColor: const Color.fromARGB(150, 107, 162, 243),
                  progressColor: isAchievementDone
                      ? Colors.green
                      : const Color.fromARGB(255, 242, 148, 44),
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: !isAchievementDone
                        ? [
                            nunitoText(
                              widget.type == AchievementType.betsWon
                                  ? "Win"
                                  : "Join",
                              14,
                              FontWeight.normal,
                              const Color.fromARGB(255, 30, 30, 27),
                            ),
                            nunitoText(
                              "${widget.valueMax}",
                              20,
                              FontWeight.bold,
                              const Color.fromARGB(255, 30, 30, 27),
                            ),
                            nunitoText(
                              widget.type == AchievementType.betsWon
                                  ? "Bets"
                                  : "Leagues",
                              14,
                              FontWeight.normal,
                              const Color.fromARGB(255, 30, 30, 27),
                            ),
                            if (!isAchievementDone)
                              nunitoText(
                                "${widget.valueCurrent!} / ${widget.valueMax}",
                                12,
                                FontWeight.normal,
                                const Color.fromARGB(255, 30, 30, 27),
                              )
                            else
                              const SizedBox(),
                          ]
                        : isRewardCollected
                            ? [
                                nunitoText(
                                  widget.type == AchievementType.betsWon
                                      ? "win ${widget.valueMax} bets"
                                      : "join ${widget.valueMax} leagues",
                                  14,
                                  FontWeight.normal,
                                  const Color.fromARGB(255, 30, 30, 27),
                                ),
                                nunitoText(
                                  widget.cosmeticName,
                                  20,
                                  FontWeight.bold,
                                  const Color.fromARGB(255, 30, 30, 27),
                                ),
                                nunitoText(
                                  "Collected",
                                  14,
                                  FontWeight.normal,
                                  const Color.fromARGB(255, 30, 30, 27),
                                ),
                              ]
                            : [
                                nunitoText(
                                  widget.type == AchievementType.betsWon
                                      ? "win ${widget.valueMax} bets"
                                      : "join ${widget.valueMax} leagues",
                                  14,
                                  FontWeight.normal,
                                  const Color.fromARGB(255, 30, 30, 27),
                                ),
                                ElevatedButton(
                                  onPressed: () => giveReward(
                                    context,
                                    widget.cosmeticName,
                                    widget.achievementName,
                                  ),
                                  child: nunitoText(
                                    "Claim",
                                    20,
                                    FontWeight.bold,
                                    Colors.green,
                                  ),
                                ),
                              ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
