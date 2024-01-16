import 'package:app/blocs/league_joining_bloc/league_joining_bloc.dart';
import 'package:app/components/league_screen/join_league_widget.dart';
import 'package:app/components/league_screen/league_widget.dart';
import 'package:app/models/league_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  
  List<String> rank = ["1", "2"];
  List<String> names = ["League 1", "League 2"];
  List<String> leagueIDs = ["0", "1"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      fetchPlayersLeagues();
    });
  }

  void resetBlocState() {
    BlocProvider.of<LeagueJoiningBloc>(context).add(CancelLeagueJoinEvent());
  }

  Future<void> fetchPlayersLeagues() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.primary, size: 55,),
        );
      },
      barrierDismissible: false,
      useRootNavigator: false,
    );

    final response = await http.get(Uri.parse('https://bet-app-e520a.ew.r.appspot.com/v1/users/$uid/leagues'));
    // print(response.body);
    setState((){
      leaguePreviewFromJson(response.body).forEach((element) {
            rank.add('${element.rank}/${element.playerCount}');
            names.add(element.leagueName);
            leagueIDs.add(element.leagueID);
          }
        );
    });

    if (mounted){
      Navigator.of(context).pop();
    }
  }

  void goToLeagueCreator(BuildContext context) {
    context.go("/leagues/creator");
  }

  void goToLeagueSummary(BuildContext context, int index) {
    context.go("/leagues/summary", extra: leagueIDs[index]);
    }

  @override
  Widget build(BuildContext context) {
    final List<Widget> leadingWidgets = rank.map(
      (e) => 
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: Color.fromARGB(255, 211, 91, 91),
          width: 50,
          height: 20,
          child: Center(
            child: Text(
              e,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        )
      ),
    ).toList();

    return Column(
      children: 
      [
        const SizedBox(height: 40,),
        JoinLeagueWidget(),
    
        const SizedBox(height: 120,),
        LeagueListWidget(
          header: "Your leagues",
          leadingWidgets: leadingWidgets,
          titles: names,
          // addons: null,
          trailingWidgets: List.generate(rank.length, (index) => const Icon(Icons.arrow_forward_ios_rounded, color: Colors.red,)),
          onTap: (int index) {
            goToLeagueSummary(context, index);
          },
          height: 300,
        ),

        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 5, 160, 221),
          ),
          onPressed: () => goToLeagueCreator(context),
          child: const Text(
            'Create league',
            style: TextStyle(color: Colors.white),
            ),
      ),
          const SizedBox(height: 40,),
    ],);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(
  //     backgroundColor: Colors.red,
  //     body: Center(
  //       child: Text(
  //         "xd",
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 30,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
