import 'package:app/components/bet.dart';
import 'package:app/components/history_screen/history_bet_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});
  final List<Bet> betList = [];
  final List<HistoryBetWidget> betWidgets = [];

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<void> getBetList() async {
    // fill betList with data from Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final CollectionReference userBets =
        firestore.collection('Users').doc(user!.uid).collection('UserBets');
    try {
      final QuerySnapshot userBetsSnapshot = await userBets.get();

      for (final QueryDocumentSnapshot betDocument in userBetsSnapshot.docs) {
        final DocumentReference betRef =
            betDocument['betRef'] as DocumentReference;
        final DocumentSnapshot betSnapshot = await betRef.get();

        if (betSnapshot.exists) {
          print('betSnapshot.data(): ${betSnapshot.data()}');
          final Bet bet =
              await Bet.create(betSnapshot.data()! as Map<String, dynamic>);
          widget.betList.add(bet);
        } else {
          print('Bet document not found for betRef: ${betRef.id}');
        }
      }
    } catch (e) {
      print('Error fetching bet list: $e');
    }
    setState(() {});
    print("bet list length: ${widget.betList.length}");
    print("betList: $widget.betList");
  }

  @override
  void initState() {
    super.initState();
    getBetList();
  }

  @override
  Widget build(BuildContext context) {
    print("build called");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                height: 50,
                child: Text(
                  'History',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
      ),
    );
  }
}
