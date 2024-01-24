import 'package:app/components/league_screen/league_widget.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/models/player_league_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LeagueSummary extends StatefulWidget {
  final String leagueID;
  const LeagueSummary({
    super.key,
    required this.leagueID,
    });

  @override
  State<LeagueSummary> createState() => _LeagueSummaryState();
}

class _LeagueSummaryState extends State<LeagueSummary> {

  List<String> ranks = [];
  List<int> points = [];
  List<String> usernames = [];
  List<String> ids = [];

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

  void moveToHistory(BuildContext context, int index) {
    context.go("/leagues/summary/history", extra: ids[index]);
  }

  Future<void> fetchLeagueData() async {
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

    final response = await http.get(Uri.parse('https://bet-app-e520a.ew.r.appspot.com/v1/leagues/${widget.leagueID}/users'));
    // print(response.body);
    setState((){
      final body = leagueSummaryFromJson(response.body);
      print(body);

      leagueName = body.leagueName;
      leagueCode = body.leagueCode;
      entryCost = body.entryCost;

      final users = body.users!;
      final int playerCount = users.length;

      users.asMap().forEach((index, element) {
        ranks.add('${index+1}');
        usernames.add(element.username!);
        points.add(element.points!);
        ids.add(element.userID!);
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
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Color.fromRGBO(255, 115, 115, 1),
          width: 40,
          height: 18,
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

    return Scaffold(
      body: Column(
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
            header: nunitoText("Your leagues", 20, FontWeight.bold, Color.fromRGBO(30, 30, 27, 1)),
            leadingWidgets: leadingWidgets,
            titles: usernames,
            // addons: points,
            trailingWidgets: points.map((e) => Text(e.toString())).toList(),
            onTap: (index) {moveToHistory(context, index);},
            height: 300,
          ),
        ],
      ),
    );
  }
}
