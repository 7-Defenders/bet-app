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
  
  List<String> rank = [];
  List<String> names = [];
  List<String> leagueIDs = [];

  final List<bool> _selected = [true, false];

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

    // if (mounted){
    //   Navigator.of(context).pop();
    // }
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
      CircleAvatar(
        backgroundColor: () {
          switch (e.split('/')[0]) {
            case '1':
              return const Color.fromARGB(255, 202, 165, 1);
            case '2':
              return const Color.fromARGB(255, 170, 170, 170);
            case '3':
              return const Color.fromARGB(255, 168, 92, 62);
            default:
              return Colors.blue;
          }
        }(),
        child: Text(e),
        ),
      ).toList();

    return Column(
      children: 
      [
        const SizedBox(height: 40,),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                final int other = (index+1)%2;
                _selected[index] = true;
                _selected[other] = false;
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.red[700],
            selectedColor: Colors.white,
            fillColor: Colors.red[200],
            color: Colors.red[400],
            constraints: const BoxConstraints(
              minHeight: 30.0,
              minWidth: 120.0,
            ),
            isSelected: _selected,
            children: const [Text('Private'), Text('Public')],
          ),
    
        const SizedBox(height: 40,),
        JoinLeagueWidget(),
    
        const SizedBox(height: 120,),
        LeagueListWidget(
          leadingWidgets: leadingWidgets,
          titles: names,
          addons: leagueIDs,
          icon: Icons.arrow_forward_ios,
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
