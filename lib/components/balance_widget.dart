import 'package:app/components/other/nunito_text.dart';
import 'package:app/providers/navigation_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key, required this.vw, required this.vh});
  final double vw;
  final double vh;

  void goToShop(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.currentIndex = 3;
  }

  Future<num> getBalance() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final DocumentReference userRef =
        firestore.collection('Users').doc(user!.uid);
    try {
      final DocumentSnapshot userSnapshot = await userRef.get();
      final num balance = userSnapshot['balance'] as num;
      return balance;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user balance: $e');
      }
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        goToShop(context);
      },
      child: FutureBuilder<num> (
        future: getBalance(),
        builder: (BuildContext context, AsyncSnapshot<num> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else {
            return Row(
              children: [
                nunitoText(
                  '${snapshot.data}',
                  6.5 * vw,
                  FontWeight.w600,
                  Theme.of(context).colorScheme.background,
                ),
                SizedBox(width: 1 * vw,),
                Icon(
                  Icons.token,
                  size: 7 * vw,
                  color: Theme.of(context).colorScheme.background,
                ),
                Icon(
                  Icons.add_rounded,
                  size: 6.5 * vw,
                  color: Theme.of(context).colorScheme.background,
                ),
              ],
            );
          }
        }
      )
    );
  }
}
