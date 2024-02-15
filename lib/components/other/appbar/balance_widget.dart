import 'package:app/components/other/nunito_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class BalanceWidget extends StatelessWidget {
  //!!!
  //TODO: get rid of vw & vh calculations
  const BalanceWidget({super.key, required this.vw, required this.vh});
  final double vw;
  final double vh;

  void goToShop(BuildContext context) {
    context.go('/shop');
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
      child: FutureBuilder<num>(
        future: getBalance(),
        builder: (BuildContext context, AsyncSnapshot<num> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else {
            return Row(
              children: [
                SvgPicture.asset(
                  'lib/assets/images/appbar/add_dollar.svg',
                  width: 7 * vw,
                  height: 7 * vw,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(1 * vw),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 214, 149),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                          child: nunitoText(
                            '${snapshot.data}',
                            5 * vw,
                            FontWeight.bold,
                            Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
