import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


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
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.tertiary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessible_forward),
            label: 'Leagues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/profile')) {
      return 0;
    }
    if (location.startsWith('/events')) {
      return 1;
    }
    if (location.startsWith('/leagues')) {
      return 2;
    }
    if (location.startsWith('/shop')){
      return 3;
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
        GoRouter.of(context).go('/leagues');
        break;
      case 3:
        GoRouter.of(context).go('/shop');
        break;
    }
  }
}
