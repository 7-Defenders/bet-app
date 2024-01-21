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

  Widget leagueInfoPopup({double height=150.0, double width=300.0}){
    final subWidth = width * 0.4;
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: subWidth,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: nunitoText('Entry fee', 16, FontWeight.normal, Colors.black),
                ),
              ),
              
              SizedBox(
                width: subWidth,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: nunitoText(entryCost == null ? 'N/A' : entryCost.toString(), 16, FontWeight.bold, Colors.black),
                ),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     nunitoText('Entry fee', 16, FontWeight.normal, Colors.black),
          //     nunitoText(entryCost == null ? 'N/A' : entryCost.toString(), 16, FontWeight.bold, Colors.black),
          //   ],
          // ),
          const Spacer(),
          
          ElevatedButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 96, 179, 255),
            ),
            child: nunitoText('Close', 14, FontWeight.bold, Colors.white),
          ),
        ],
      ),
    );
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
        ranks.add('${index+1}/$playerCount');
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
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: Color.fromARGB(255, 211, 91, 91),
          width: 40,
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

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black,),
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  content: leagueInfoPopup(),
                ),
              );
            },
          ),
        ],
        title: nunitoText(leagueName == null ? 'League Name' : leagueName!, 24, FontWeight.bold, Colors.black),
        centerTitle: true,
      ),
      body: Column(
        children: 
        [
          const SizedBox(height: 40,),
          GestureDetector(
            onTap: () {
              Clipboard.setData(
                ClipboardData(
                  text: leagueCode!,
                ),
              );
              
              final snackBar = SnackBar(
                backgroundColor: const Color.fromARGB(255, 96, 179, 255),
                content: nunitoText('Copied league code to clipboard.', 16, FontWeight.normal, Colors.white),
              );

              scaffoldMessenger.showSnackBar(snackBar)
                .closed.then((value) => scaffoldMessenger.clearSnackBars());
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  nunitoText(leagueCode == null ? 'League Name' : leagueCode!, 25, FontWeight.bold, Colors.black),
                  const SizedBox(width: 10,),
                  const Icon(Icons.copy),
                ],
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
            header: "Standings",
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
