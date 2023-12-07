import 'package:app/components/bet.dart';
import 'package:app/components/history_screen/history_bet_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Bet> betList = [];

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
          betList.add(bet);
        } else {
          print('Bet document not found for betRef: ${betRef.id}');
        }
      }
    } catch (e) {
      print('Error fetching bet list: $e');
    }
    // setState(() {});
    print("bet list length: ${betList.length}");
    print("betList: $betList");
  }

  @override
  Widget build(BuildContext context) {
    print("build called");
    return Scaffold(
      body: FutureBuilder(
        future: getBetList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading bet list: ${snapshot.error}'),
            );
          } else {
            final List<Widget> betWidgets =
                betList.map((bet) => HistoryBetWidget(bet: bet)).toList();
            print("betWidgets: $betWidgets");

            return ListView(
              children: betWidgets,
            );
          }
        },
      ),
    );
  }
}
