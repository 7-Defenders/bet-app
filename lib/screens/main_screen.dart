import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/screens/navbar_screens/events_screen.dart';
import 'package:app/screens/navbar_screens/leagues_screen.dart';
import 'package:app/screens/navbar_screens/profile_screen.dart';
import 'package:app/screens/navbar_screens/shop_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> pages = const [
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
    // return Scaffold(
    //   body: pages[currentIndex],
    //   bottomNavigationBar: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: [
    //       buildNavBarItem(FontAwesomeIcons.user, 0, 'Profile'),
    //       buildNavBarItem(FontAwesomeIcons.futbol, 1, 'Events'),
    //       buildNavBarItem(FontAwesomeIcons.trophy, 2, 'Leagues'),
    //       buildNavBarItem(FontAwesomeIcons.cartShopping, 3, 'Shop'),
    //     ],
    //   ),
    // );
    return Column(
      children: [
        Expanded(
          child: pages[currentIndex],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNavBarItem(FontAwesomeIcons.user, 0, 'Profile'),
                buildNavBarItem(FontAwesomeIcons.futbol, 1, 'Events'),
                buildNavBarItem(FontAwesomeIcons.trophy, 2, 'Leagues'),
                buildNavBarItem(FontAwesomeIcons.cartShopping, 3, 'Shop'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNavBarItem(IconData iconData, int index, String label, {double iconSize=25}) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: isSelected
                  // ? const Color.fromARGB(255, 93, 183, 172)
                  ? const Color.fromARGB(255, 93, 100, 255)
                  : Colors.transparent,
                  // : Colors.grey[600]!,
              width: isSelected ? 2 : 0,
            ),
          ),
        ),
        child: Icon(
          iconData,
          color: isSelected
              // ? const Color.fromARGB(255, 93, 183, 172)
              ? const Color.fromARGB(255, 93, 100, 255)
              : Colors.grey[600],
          size: iconSize,
        ),
      ),
    );
  }
}
