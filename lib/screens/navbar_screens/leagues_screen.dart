import 'package:app/components/events_screen/bet_preview.dart';
import 'package:app/components/league_screen/join_league_widget.dart';
import 'package:app/components/league_screen/league_widget.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/models/football_event.dart';
import 'package:app/models/league_preview.dart';
import 'package:app/models/structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:app/blocs/league_joining_bloc/league_joining_bloc.dart';
import 'package:app/providers/navigation_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  late NavigationProvider navigationProvider;
  
  List<String> rank = [];
  List<String> names = [];

  final List<bool> _selected = [true, false];

  @override
  void initState() {
    super.initState();
    navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.addListener(resetBlocState);
    WidgetsBinding.instance.addPostFrameCallback((_){
      fetchPlayersLeagues();
    });
  }

  @override
  void dispose() {
    navigationProvider.removeListener(resetBlocState);
    super.dispose();
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
    print(response.body);
    setState((){
      leaguePreviewFromJson(response.body).forEach((element) {
            rank.add('${element.rank}/${element.playerCount}');
            names.add(element.leagueName);
          }
        );
    });

    if (mounted){
      Navigator.of(context).pop();
    }
  }

  void moveToLeagueCreator(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.currentIndex = 6;
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
        )
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
          icon: Icons.arrow_forward_ios,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('League item tapped')),
            );
          },
          height: 300,
        ),

        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 5, 160, 221),
          ),
          onPressed: () => moveToLeagueCreator(context),
          child: const Text(
            'Create league',
            style: TextStyle(color: Colors.white),
            ),
      ),
          const SizedBox(height: 40,),
    ],);
  }
}
