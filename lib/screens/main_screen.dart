import 'package:app/screens/navbar_screens/events_screen.dart';
import 'package:app/screens/navbar_screens/leagues_screen.dart';
import 'package:app/screens/navbar_screens/profile_screen.dart';
import 'package:app/screens/navbar_screens/shop_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> pages = const [
    ProfileScreen(),
    EventsScreen(),
    LeaguesScreen(),
    ShopScreen(),
  ];

  int currentIndex = 1;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SizedBox(
        height: 80,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)), // Match the radius of the decoration
          child: ColoredBox(
            color: const Color(0xffffb303),
            child: BottomNavigationBar(
              onTap: onTap,
              currentIndex: currentIndex,
              elevation: 20,
              showSelectedLabels: true,
              selectedItemColor: Colors.black,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.sports_soccer,
                    color: Colors.black,
                  ),
                  label: 'Events',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.emoji_events,
                    color: Colors.black,
                  ),
                  label: 'Leagues',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  label: 'Shop',
                ),
              ],
              selectedFontSize: 15,
              iconSize: 33,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
    ),
    );
  }
}
