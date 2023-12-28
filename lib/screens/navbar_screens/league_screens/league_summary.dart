import 'package:app/components/league_screen/league_widget.dart';
import 'package:app/models/player_league_summary.dart';
import 'package:app/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LeagueSummary extends StatefulWidget {
  final String leagueID;
  const LeagueSummary({
    super.key,
    required this.leagueID,
    });

  @override
  // ignore: no_logic_in_create_state
  State<LeagueSummary> createState() => _LeagueSummaryState(leagueID: leagueID);
}

class _LeagueSummaryState extends State<LeagueSummary> {
  final String leagueID;

  _LeagueSummaryState({
    required this.leagueID,
  });

  late NavigationProvider navigationProvider;

  List<String> ranks = [];
  List<int> points = [];
  List<String> usernames = [];

  String? leagueName;
  String? leagueCode;
  int? entryCost;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      fetchLeagueData();
    });
  }

  Future<void> fetchLeagueData() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.primary, size: 55,),
        );
      },
    );

    final response = await http.get(Uri.parse('https://bet-app-e520a.ew.r.appspot.com/v1/leagues/$leagueID/users'));
    // print(response.body);
    setState((){
      final body = leagueSummaryFromJson(response.body);
      // print(body);

      leagueName = body.leagueName;
      leagueCode = body.leagueCode;
      entryCost = body.entryCost;

      final users = body.users!;
      final int playerCount = users.length;

      users.asMap().forEach((index, element) {
        ranks.add('${index+1}/$playerCount');
        usernames.add(element.username!);
        points.add(element.points!);
      });

      if (mounted){
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> leadingWidgets = ranks.map(
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
        Center(
          child: Text(
            leagueName == null ? 'League Name' : leagueName!,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 40,),
        Material(
          child: InkWell(
            onTap: () {
              Clipboard.setData(
                ClipboardData(
                  text: leagueCode!,
                ),
              );
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    leagueCode == null ? 'League Name' : leagueCode!,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  const Icon(Icons.copy),
                ],
              ),
            ),
          ),
        ),      
        const SizedBox(height: 25,),
        Center(
          child: Text(
            'Entry cost - ${entryCost == null ? 'N/A' : entryCost!}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),  
        const SizedBox(height: 80,),
        LeagueListWidget(
          leadingWidgets: leadingWidgets,
          titles: usernames,
          // addons: points,
          icon: Icons.arrow_forward_ios,
          onTap: (index) {},
          height: 300,
        ),
    ],);
  }
}
