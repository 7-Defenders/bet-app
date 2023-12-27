import 'package:app/providers/navigation_provider.dart';
import 'package:app/screens/achievements_screen.dart';
import 'package:app/screens/drawer.dart';
import 'package:app/screens/history_screen.dart';
import 'package:app/screens/navbar_screens/events_screen.dart';
import 'package:app/screens/navbar_screens/league_screens/league_creator.dart';
import 'package:app/screens/navbar_screens/leagues_screen.dart';
import 'package:app/screens/navbar_screens/profile_screen.dart';
import 'package:app/screens/navbar_screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:card_swiper/card_swiper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> pages = [
    const ProfileScreen(),
    const EventsScreen(),
    const LeaguesScreen(),
    ShopScreen(),
    HistoryScreen(), // this wont be on navbar, but needs to be here for NavigationProvider
    const AchievementsScreen(), // this wont be on navbar, but needs to be here for NavigationProvider
    const LeagueCreator(), // this wont be on navbar, but needs to be here for NavigationProvider
  ];

  late int currentIndex;
  late NavigationProvider navigationProvider;

  void onTap(int index) {
    navigationProvider.currentIndex = index;
  }

  @override
  void initState() {
    super.initState();
    navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    currentIndex = navigationProvider.currentIndex;
    navigationProvider.addListener(updateIndex);
  }

  @override
  void dispose() {
    navigationProvider.removeListener(updateIndex);
    super.dispose();
  }

  void updateIndex() {
    setState(() {
      currentIndex = navigationProvider.currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double vh = MediaQuery.of(context).size.height / 100;
    final double vw = MediaQuery.of(context).size.width / 100;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: drawer(context, vw, vh),
      body: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
        return Column(
          children: [
            Expanded(
              child: pages[navigationProvider.currentIndex],
            ),
            Align(
              alignment: Alignment.bottomCenter,
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
          ],
        );
      },),
    );
  }

  Widget buildNavBarItem(
    IconData iconData,
    int index,
    String label, {
    double iconSize = 25,
  }) {
    final isSelected = index == currentIndex || 
                      (index == 0 && (currentIndex == 4 || currentIndex == 5)) || 
                      (index == 2 && (currentIndex == 6));
    /*
      this is because the history and achievements screens are not on the navbar
      and they can only be accessed from the profile screen
      hence why the profile icon is highlighted when on those screens.
     */

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onTertiary,
          border: Border(
            top: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: isSelected ? 2 : 0,
            ),
          ),
        ),
        child: Icon(
          iconData,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.tertiary,
          size: iconSize,
        ),
      ),
    );
  }
}
