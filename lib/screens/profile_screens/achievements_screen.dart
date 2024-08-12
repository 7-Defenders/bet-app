// import 'package:app/components/other/appbar/custom_appbar.dart';
// import 'package:app/components/other/nunito_text.dart';
// import 'package:app/models/user_data.dart';
// import 'package:app/providers/user_data_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AchievementsScreen extends StatefulWidget {
//   const AchievementsScreen({super.key});

//   @override
//   State<AchievementsScreen> createState() => _AchievementsScreenState();
// }

// enum AchievementType {
//   betsWon,
//   leaguesJoined,
// }

// class _AchievementsScreenState extends State<AchievementsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final UserData? userData =
//         Provider.of<UserDataProvider>(context, listen: false).userData;

//     return Scaffold(
//       appBar: CustomAppbar(
//         56,
//         IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             GoRouter.of(context).pop();
//           },
//         ),
//         'Achievements',
//         null,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: achievementsList(userData, context),
//         ),
//       ),
//     );
//   }
// }

// List<Widget> achievementsList(UserData? userData, BuildContext context) {
//   final achievements = [
//     AchievementWidget(
//       achievementName: "Winner",
//       type: AchievementType.betsWon,
//       valueCurrent: userData?.betsWon ?? 0,
//       valueMax: 10,
//       cosmeticName: "blue boss",
//     ),
//     AchievementWidget(
//       achievementName: "Explorer",
//       type: AchievementType.leaguesJoined,
//       valueCurrent: userData?.leaguesJoined ?? 0,
//       valueMax: 1,
//       cosmeticName: "romantic",
//     ),
//     AchievementWidget(
//       achievementName: "The Brave One",
//       type: AchievementType.leaguesJoined,
//       valueCurrent: userData?.leaguesJoined ?? 0,
//       valueMax: 3,
//       cosmeticName: "groovy",
//     ),
//     AchievementWidget(
//       achievementName: "Serious Player",
//       type: AchievementType.leaguesJoined,
//       valueCurrent: userData?.leaguesJoined ?? 0,
//       valueMax: 5,
//       cosmeticName: "purple madness",
//     ),
//   ];

//   final completedAchievements = achievements
//       .where((widget) =>
//           widget.valueCurrent != null &&
//           widget.valueCurrent! >= widget.valueMax)
//       .toList();

//   final uncompletedAchievements = achievements
//       .where((widget) =>
//           widget.valueCurrent == null || widget.valueCurrent! < widget.valueMax)
//       .toList();

//   return [
//     const SizedBox(height: 40),
//     Padding(
//       padding: const EdgeInsets.only(left: 20),
//       child: nunitoText(
//         'Uncompleted',
//         20,
//         FontWeight.bold,
//         const Color.fromARGB(255, 30, 30, 27),
//       ),
//     ),
//     GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       children: uncompletedAchievements,
//     ),
//     Padding(
//       padding: const EdgeInsets.only(left: 20),
//       child: nunitoText(
//         'Completed',
//         20,
//         FontWeight.bold,
//         const Color.fromARGB(255, 30, 30, 27),
//       ),
//     ),
//     GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       children: completedAchievements,
//     ),
//   ];
// }

// class AchievementWidget extends StatefulWidget {
//   final String achievementName;
//   final AchievementType type;
//   final num? valueCurrent;
//   final num valueMax;
//   final String cosmeticName;

//   const AchievementWidget({
//     required this.achievementName,
//     required this.type,
//     required this.valueCurrent,
//     required this.valueMax,
//     required this.cosmeticName,
//     super.key,
//   });

//   @override
//   _AchievementWidgetState createState() => _AchievementWidgetState();
// }

// class _AchievementWidgetState extends State<AchievementWidget> {
//   bool isRewardCollected = false;

//   Future<void> giveReward(
//     BuildContext context,
//     String cosmeticName,
//     String achievementName,
//   ) async {
//     final uid =
//         Provider.of<UserDataProvider>(context, listen: false).userData?.uid;
//     final uri = Uri.encodeFull(
//       'https://flask-vhn3gxevdq-ew.a.run.app/v1/users/$uid/cosmetics/$cosmeticName',
//     );
//     final response = await http.post(Uri.parse(uri));

//     if (context.mounted) {
//       if (response.statusCode == 200) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('$achievementName achievement', true);
//         setState(() {
//           isRewardCollected = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("You recievsed a new cosmetic: $cosmeticName!"),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Failed to give reward"),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isAchievementDone =
//         widget.valueCurrent != null && widget.valueCurrent! >= widget.valueMax;

//     return FutureBuilder<SharedPreferences>(
//       future: SharedPreferences.getInstance(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const CircularProgressIndicator();
//         }

//         final prefs = snapshot.data!;
//         isRewardCollected =
//             prefs.getBool('${widget.achievementName} achievement') ?? false;

//         return LayoutBuilder(
//           builder: (context, constraints) {
//             return Container(
//               padding: const EdgeInsets.all(10),
//               child: GestureDetector(
//                 onTap: !isRewardCollected
//                     ? () => giveReward(
//                           context,
//                           widget.cosmeticName,
//                           widget.achievementName,
//                         )
//                     : null,
//                 child: CircularPercentIndicator(
//                   radius: constraints.maxWidth * 0.36,
//                   animation: true,
//                   animationDuration: 1200,
//                   lineWidth: 15.0,
//                   percent: (widget.valueCurrent! / widget.valueMax) > 1
//                       ? 1
//                       : (widget.valueCurrent! / widget.valueMax),
//                   backgroundColor: const Color.fromARGB(150, 107, 162, 243),
//                   progressColor: isAchievementDone
//                       ? Colors.green
//                       : const Color.fromARGB(255, 242, 148, 44),
//                   center: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: !isAchievementDone
//                         ? [
//                             nunitoText(
//                               widget.type == AchievementType.betsWon
//                                   ? "Win"
//                                   : "Join",
//                               14,
//                               FontWeight.normal,
//                               const Color.fromARGB(255, 30, 30, 27),
//                             ),
//                             nunitoText(
//                               "${widget.valueMax}",
//                               20,
//                               FontWeight.bold,
//                               const Color.fromARGB(255, 30, 30, 27),
//                             ),
//                             nunitoText(
//                               widget.type == AchievementType.betsWon
//                                   ? "Bets"
//                                   : "Leagues",
//                               14,
//                               FontWeight.normal,
//                               const Color.fromARGB(255, 30, 30, 27),
//                             ),
//                             if (!isAchievementDone)
//                               nunitoText(
//                                 "${widget.valueCurrent!} / ${widget.valueMax}",
//                                 12,
//                                 FontWeight.normal,
//                                 const Color.fromARGB(255, 30, 30, 27),
//                               )
//                             else
//                               const SizedBox(),
//                           ]
//                         : isRewardCollected
//                             ? [
//                                 nunitoText(
//                                   widget.type == AchievementType.betsWon
//                                       ? "win ${widget.valueMax} bets"
//                                       : "join ${widget.valueMax} leagues",
//                                   14,
//                                   FontWeight.normal,
//                                   const Color.fromARGB(255, 30, 30, 27),
//                                 ),
//                                 nunitoText(
//                                   widget.cosmeticName,
//                                   20,
//                                   FontWeight.bold,
//                                   const Color.fromARGB(255, 30, 30, 27),
//                                 ),
//                                 nunitoText(
//                                   "Collected",
//                                   14,
//                                   FontWeight.normal,
//                                   const Color.fromARGB(255, 30, 30, 27),
//                                 ),
//                               ]
//                             : [
//                                 nunitoText(
//                                   widget.type == AchievementType.betsWon
//                                       ? "win ${widget.valueMax} bets"
//                                       : "join ${widget.valueMax} leagues",
//                                   14,
//                                   FontWeight.normal,
//                                   const Color.fromARGB(255, 30, 30, 27),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () => giveReward(
//                                     context,
//                                     widget.cosmeticName,
//                                     widget.achievementName,
//                                   ),
//                                   child: nunitoText(
//                                     "Claim",
//                                     20,
//                                     FontWeight.bold,
//                                     Colors.green,
//                                   ),
//                                 ),
//                               ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
