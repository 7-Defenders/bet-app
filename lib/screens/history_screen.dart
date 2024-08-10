import 'package:app/components/history_screen/history_bet_widget.dart';
import 'package:app/globals.dart';
import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/models/bet.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HistoryScreen extends StatefulWidget {

  final String? userID;
  HistoryScreen({super.key, this.userID});

  List<Bet> betList = [];
  final List<HistoryBetWidget> betWidgets = [];

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBetList();
    });
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  Future<void> getBetList() async {
    // print(widget.userID);
    widget.betList.clear();

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

    final String userID = Globals.uid;
    // print('userID: $userID');

    final dateTime = DateTime.now().subtract(const Duration(days: 7)).toUtc();
    final day = DateTime.now().subtract(const Duration(days: 1)).toUtc();
    final uriWeek = 'https://bet-app-e520a.ew.r.appspot.com/v1/bets/$userID?startDate=${dateTime.year}/${dateTime.month}/${dateTime.day}/${dateTime.hour}';
    final uriDay = 'https://bet-app-e520a.ew.r.appspot.com/v1/bets/$userID?startDate=${day.year}/${day.month}/${day.day}/${day.hour}';

    final response = Globals.shouldCall(uriWeek) ? await Globals.performCall(uriWeek) : Globals.hasNewBet ? await Globals.loadMoreBets(uriDay) : Globals.getBets();

    setState(() {
      // print(response.body);
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
    });

    if (mounted) {
      Navigator.of(context).pop();
    }
    // // fill betList with data from Firestore
    // final FirebaseFirestore firestore = FirebaseFirestore.instance;
    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final User? user = auth.currentUser;
    // final CollectionReference userBets =
    //     firestore.collection('Users').doc(userID == null ? user!.uid : userID!).collection('UserBets');
    // try {
    //   final QuerySnapshot userBetsSnapshot = await userBets.get();

    //   for (final QueryDocumentSnapshot betDocument in userBetsSnapshot.docs) {
    //     final DocumentReference betRef =
    //         betDocument['betRef'] as DocumentReference;
    //     final DocumentSnapshot betSnapshot = await betRef.get();

    //     if (betSnapshot.exists) {
    //       final Bet bet =
    //           await Bet.create(betSnapshot.data()! as Map<String, dynamic>);
    //       widget.betList.add(bet);
    //     } else {
    //     }
    //   }
    // } catch (e) {
    //   if (kDebugMode) {
    //     print('Error fetching bet list: $e');
    //   }
    // }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // return PopScope(
      // canPop: false,
      // onPopInvoked: (didPop) {
      //   goBack();
      // },
      // child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppbar(
        56,
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: goBack,
        ),
        'History',
        null,
      ),
      body: Column(
        children: [
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
    //   ),
    // );
  }
}
