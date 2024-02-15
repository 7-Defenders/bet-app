import 'package:app/components/other/appbar/balance_widget.dart';
import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/components/shop_screen/add_points_widget.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    //TODO: move all vw and vh calculations to constants file or find a better way to handle them
    final double vw = MediaQuery.of(context).size.width / 100;
    final double vh = MediaQuery.of(context).size.height / 100;
    final userData = Provider.of<UserDataProvider>(context).userData;

    Future<void> logOutUser() async {
      Provider.of<UserDataProvider>(context, listen: false).userData = null;
      await FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      appBar: CustomAppbar(
        56,
        null,
        'Shop',
        [
          Padding(
            padding: EdgeInsets.only(right: vw * 3),
            child: BalanceWidget(vw: vw, vh: vh),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text('Random Text'),
                  SizedBox(height: 20),
                  AddPointsWidget(),
                  //using this screen as a playground for the user data provider
                  if (userData != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Display Name: ${userData.displayName ?? 'N/A'}',
                          ),
                          Text('Email: ${userData.email ?? 'N/A'}'),
                          Text('Photo URL: ${userData.photoURL ?? 'N/A'}'),
                          Text(
                            'Email Verified: ${userData.emailVerified ? 'Yes' : 'No'}',
                          ),
                          Text('UID: ${userData.uid}'),
                        ],
                      ),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                  ElevatedButton(
                    onPressed: logOutUser,
                    child: const Text('Log Out'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final UserData? userdata =
                          Provider.of<UserDataProvider>(context, listen: false)
                              .userData;
                      print(userdata);
                    },
                    child: const Text('show user data'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
