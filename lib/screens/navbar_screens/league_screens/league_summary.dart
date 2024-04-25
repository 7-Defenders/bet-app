import 'package:app/components/league_screen/league_widget.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/globals.dart';
import 'package:app/models/player_league_summary.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<String>? competitionRefs = [];

  String? leagueName;
  String? leagueCode;
  int? entryCost;
  bool? private;

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

    Widget confirmLeaving(){
    final height = MediaQuery.of(context).size.height * 0.2;
    final width = MediaQuery.of(context).size.width * 0.75;
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        children: [
          nunitoText("Are you sure?", 22, FontWeight.bold, Colors.black),
          nunitoText("You will lose your league points forever.", 16, FontWeight.normal, Colors.black),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                ElevatedButton(
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: nunitoText('No, stay', 14, FontWeight.normal, Colors.white),
              ),

              ElevatedButton(
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  Navigator.of(context).pop();
                  Navigator.of(context, rootNavigator: true).pop();
                  await leaveLeague();
                  
                  final snackBar = SnackBar(
                    backgroundColor: const Color.fromARGB(255, 96, 179, 255),
                    content: nunitoText('Successfully left $leagueName.', 16, FontWeight.normal, Colors.white),
                  );
                  
                  scaffoldMessenger.showSnackBar(snackBar)
                    .closed.then((value) => scaffoldMessenger.clearSnackBars());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: nunitoText('Yes, leave', 14, FontWeight.bold, Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget leagueInfoPopup({double height=300.0, double width=300.0}){
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
          const SizedBox(height: 8,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: subWidth,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: nunitoText('League type', 16, FontWeight.normal, Colors.black),
                ),
              ),
              
              SizedBox(
                width: subWidth,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: nunitoText(private == null ? 'Friend' : private! ? 'Private' : 'Public', 16, FontWeight.bold, Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),

          SizedBox(
            height: height * 0.5,
            width: width,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: competitionRefs == null ? 0 : competitionRefs!.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  title: nunitoText('Competitions included', 16, FontWeight.normal, Colors.black),
                  children: competitionRefs!.map((league) {
                    return ListTile(
                      title: nunitoText(competitionRefs![index], 16, FontWeight.bold, Colors.black),
                    );
                  }).toList(),
                );
              },
            ),
          ),
    
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

  Future<void> leaveLeague() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await http.delete(Uri.parse('https://flask-vhn3gxevdq-ew.a.run.app/v1/users/$uid/leagues/${widget.leagueID}'));
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

    final uri = 'https://flask-vhn3gxevdq-ew.a.run.app/v1/leagues/${widget.leagueID}/users';
    final response = await Globals.performCall(uri);
    // print(response.body);
    setState((){
      final body = leagueSummaryFromJson(response);
      // print(body.competitionsIncluded);

      leagueName = body.leagueName;
      leagueCode = body.leagueCode;
      entryCost = body.entryCost;
      competitionRefs = body.competitionsIncluded;
      private = body.private;

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
          const SizedBox(height: 20,),
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
          const SizedBox(height: 40,),
          LeagueListWidget(
            header: nunitoText("Standings", 20, FontWeight.bold, const Color.fromRGBO(30, 30, 27, 1)),
            leadingWidgets: leadingWidgets,
            titles: usernames,
            // addons: points,
            trailingWidgets: points.map((e) => Text(e.toString())).toList(),
            onTap: (index) {moveToHistory(context, index);},
            height: MediaQuery.of(context).size.height * 0.5,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  content: confirmLeaving(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: nunitoText('Leave the league', 14, FontWeight.bold, Colors.white),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
        ],
      ),
    );
  }
}
