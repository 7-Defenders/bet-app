import 'package:app/components/league_screen/join_league_widget.dart';
import 'package:app/components/league_screen/league_widget.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/globals.dart';
import 'package:app/models/league_preview.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  late UserData? userData;

  List<String> rank = [];
  List<String> names = [];
  List<String> leagueIDs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPlayersLeagues();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userData = Provider.of<UserDataProvider>(context).userData;
  }

  Future<void> fetchPlayersLeagues() async {

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

    final uri = 'https://flask-vhn3gxevdq-ew.a.run.app/v1/users/$uid/leagues';
    final response = await Globals.performCall(uri);

    rank = [];
    names = [];
    leagueIDs = [];

    // debugPrint(response.body);
    setState(() {
      leaguePreviewFromJson(response).forEach((element) {
        rank.add('${element.rank}/${element.playerCount}');
        names.add(element.leagueName);
        leagueIDs.add(element.leagueID);
      });
    });

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> goToLeagueCreator(BuildContext context) async {
    final shouldRefresh = await context.push<bool>('/leagues/creator');
    if (shouldRefresh ?? false) {
      setState(() {
        fetchPlayersLeagues();
      });
    }
  }

  Future<void> goToLeagueSummary(BuildContext context, int index) async{
    final shouldRefresh = await context.push<bool>("/leagues/summary", extra: leagueIDs[index]);
    if (shouldRefresh ?? false) {
      setState(() {
        fetchPlayersLeagues();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> leadingWidgets = rank
        .map(
          (e) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: const Color.fromRGBO(255, 115, 115, 1),
              width: 40,
              height: 18,
              child: Center(
                child: Text(
                  e,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: nunitoText('Leagues', 26, FontWeight.bold, Colors.black),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: SizedBox(
            height: height * 0.8,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                LeagueListWidget(
                  header: nunitoText("Your leagues", 20, FontWeight.bold,
                      const Color.fromRGBO(30, 30, 27, 1),),
                  leadingWidgets: leadingWidgets,
                  titles: names,
                  // addons: null,
                  trailingWidgets: List.generate(
                      rank.length,
                      (index) => const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.red,
                          ),),
                  onTap: (int index) async {
                    await goToLeagueSummary(context, index);
                  },
                  height: height * 0.5,
                ),
                const Spacer(),
                JoinLeagueWidget(fetchPlayersLeagues),
                SizedBox(
                  height: height * 0.025,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 5, 160, 221),
                  ),
                  onPressed: () async {await goToLeagueCreator(context);},
                  child: nunitoText("Create a league", 16, FontWeight.normal, Colors.white),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     debugPrint('Name: ${userData?.email}');
                //     debugPrint('balance: ${userData?.balance}');
                //     debugPrint('leagues joined: ${userData?.leaguesJoined}');
                //   },
                //   child: const Text('Print User Data'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
