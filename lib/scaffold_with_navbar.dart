import 'package:app/components/other/navbar/custom_navbar.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:app/screens/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Builds the "shell" for the app by building a [Scaffold] with a
/// [BottomNavigationBar], where [child] is placed in the body of the [Scaffold].

class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  /// The widget to display in the body of the Scaffold.
  /// Here, it is a Navigator.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //TODO: Use a splash screen to load everything and use this microtask there
    if (Provider.of<UserDataProvider>(context, listen: false).userData ==
        null) {
      Future.microtask(
        () => Provider.of<UserDataProvider>(context, listen: false)
            .requestUserData(FirebaseAuth.instance.currentUser!.uid)
            .then((UserData? newData) {
          Provider.of<UserDataProvider>(context, listen: false).userData =
              newData;
        }),
      );
    }

    return Scaffold(
      drawer: drawer(
        context,
        MediaQuery.of(context).size.width / 100,
        MediaQuery.of(context).size.height / 100,
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: customNavbar(
        context,
        _calculateSelectedIndex(context),
        (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final Map<String, int> locationToIndex = {
      '/profile': 0,
      '/events': 1,
      '/home': 2,
      '/leagues': 3,
      '/shop': 4,
    };

    for (final entry in locationToIndex.entries) {
      if (location.startsWith(entry.key)) {
        return entry.value;
      }
    }

    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/profile');
        break;
      case 1:
        GoRouter.of(context).go('/events');
        break;
      case 2:
        GoRouter.of(context).go('/home');
        break;
      case 3:
        GoRouter.of(context).go('/leagues');
        break;
      case 4:
        GoRouter.of(context).go('/shop');
        break;
    }
  }
}
