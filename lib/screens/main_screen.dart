import 'package:app/screens/drawer.dart';
import 'package:app/screens/navbar_screens/events_screen.dart';
import 'package:app/screens/navbar_screens/leagues_screen.dart';
import 'package:app/screens/navbar_screens/profile_screen.dart';
import 'package:app/screens/navbar_screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  void Function(String)? onLanguageChange;
  String selectedLanguage = 'English';
  String? displayName;

  @override
  void initState() {
    getSelectedLanguage().then((language) {
      setState(() {
        selectedLanguage = language;
      });
    });
    onLanguageChange = setSelectedLanguage;
    super.initState();
  }

  final List<Widget> pages = [
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

  Future<String> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    return selectedLanguage;
  }

  void setSelectedLanguage(String newLanguage) {
    setState(() {
      selectedLanguage = newLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {

    final double vh = MediaQuery.of(context).size.height/100;
    final double vw = MediaQuery.of(context).size.width/100;

    return Scaffold(
      drawer: drawer(context, vw, vh, selectedLanguage, setSelectedLanguage),
      body: Column(
        children: [
          Expanded(
            child: pages[currentIndex],
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
      ),
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
