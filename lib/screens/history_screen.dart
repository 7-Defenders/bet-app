import 'package:app/components/bet.dart';
import 'package:app/components/history_screen/history_bet_widget.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/providers/navigation_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  String? userID;
  HistoryScreen({super.key, this.userID});
  final List<Bet> betList = [];
  final List<HistoryBetWidget> betWidgets = [];

  @override
  // ignore: no_logic_in_create_state
  State<HistoryScreen> createState() => _HistoryScreenState(userID: userID);
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? userID;
  _HistoryScreenState({this.userID});

  Future<void>? getBetListFuture;

  void goToProfile() {
    final NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.currentIndex = 0;
  }

  Future<void> getBetList() async {
    widget.betList.clear();
    // fill betList with data from Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final CollectionReference userBets =
        firestore.collection('Users').doc(userID == null ? user!.uid : userID!).collection('UserBets');
    try {
      final QuerySnapshot userBetsSnapshot = await userBets.get();

      for (final QueryDocumentSnapshot betDocument in userBetsSnapshot.docs) {
        final DocumentReference betRef =
            betDocument['betRef'] as DocumentReference;
        final DocumentSnapshot betSnapshot = await betRef.get();

        if (betSnapshot.exists) {
          final Bet bet =
              await Bet.create(betSnapshot.data()! as Map<String, dynamic>);
          widget.betList.add(bet);
        } else {
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching bet list: $e');
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getBetListFuture = getBetList();
  }

  @override
  Widget build(BuildContext context) {

    final double vw = MediaQuery.of(context).size.width / 100;
    final double vh = MediaQuery.of(context).size.height / 100;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        goToProfile();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 5* vh, // artificial padding for 'History' text that makes color go under the notch
                  //TODO: check if theres a way to get safe area height
                ),
                Container(
                  height: 10* vh,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    // color: Colors.red,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                goToProfile();
                              },
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                size: vw * 8,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ],
                        ),
                      ),
                      nunitoText(
                        'History',
                        30,
                        FontWeight.bold,
                        Theme.of(context).colorScheme.background,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: getBetListFuture,
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView(
                      children: widget.betList
                          .map((bet) => HistoryBetWidget(bet: bet))
                          .toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
