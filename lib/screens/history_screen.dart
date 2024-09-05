import 'package:app/components/history_screen/history_bet_widget.dart';
import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/components/profile_screen/profile_area.dart';
import 'package:app/globals.dart';
import 'package:app/models/bet.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HistoryScreen extends StatefulWidget {

  final String? userID;
  HistoryScreen({super.key, this.userID});

  List<Bet> betList = [];
  final List<HistoryBetWidget> betWidgets = [];

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  late bool isCurrentUser;
  late UserData? userData;
  late String userID;

  @override
  void initState() {
    super.initState();
    
    if (widget.userID == null || widget.userID == Globals.uid) {
      userID = Globals.uid;
      isCurrentUser = true;
    }
    else {
      userID = widget.userID!;
      isCurrentUser = false;
    }
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  Future<void> getUserHistory() async {
    // debugPrint(widget.userID);
    widget.betList.clear();

    if (!isCurrentUser){
      userData = await Provider.of<UserDataProvider>(context, listen: false).requestUserData(widget.userID!);
    } else {
      userData = Provider.of<UserDataProvider>(context).userData;
    }

    final dateTime = DateTime.now().subtract(const Duration(days: 7)).toUtc();
    final day = DateTime.now().subtract(const Duration(days: 1)).toUtc();
    final uriWeek = 'https://flask-vhn3gxevdq-ew.a.run.app/v1/bets/$userID?startDate=${dateTime.year}/${dateTime.month}/${dateTime.day}/${dateTime.hour}';
    final uriDay = 'https://flask-vhn3gxevdq-ew.a.run.app/v1/bets/$userID?startDate=${day.year}/${day.month}/${day.day}/${day.hour}';

    String response;
    if (!isCurrentUser){
      response = Globals.shouldCall(uriWeek) ? await Globals.performCall(uriWeek) : Globals.getBets(userID: userID);
    }
    else {
      response = Globals.shouldCall(uriWeek) ? await Globals.performCall(uriWeek) : Globals.hasNewBet ? await Globals.loadMoreBets(uriDay) : Globals.getBets();
    }

    widget.betList = betFromJson(response);
    widget.betList.sort(
      (a,b) {
        if (a.game == null){
          return 1;
        }
        if (b.game == null){
          return 0;
        }

        final aDate = a.game!.date??= DateTime(2000,);
        final bDate = b.game!.date??= DateTime(2000,);

        return bDate.compareTo(aDate);
      }
    );
  }
  
  Widget historyWithProfile(BuildContext context) {
    if (userData == null) {
      FirebaseAuth.instance.signOut();
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: constraints.maxHeight * 0.4,
                child: buildProfileArea(userData!, context, backArrow: true, isCurrentUser: isCurrentUser),
              ),
              Expanded(
                child: ListView(
                  children: widget.betList
                      .map((bet) => HistoryBetWidget(bet: bet))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getUserHistory(),
      builder:(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: historyWithProfile(context),
          );
        }
        else {
          return Center(
            child: LoadingAnimationWidget.hexagonDots(
              color: Theme.of(context).colorScheme.primary,
              size: 55,
            ),          
          );
        }
      },
    );
  }
}
