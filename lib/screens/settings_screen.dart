import 'package:app/components/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'English';
  String selectedOddsFormat = 'Decimal';
  String selectedNotificationsOption = 'EndOfEveryMatch';
  String selectedDarkModeEnabled =
      "off"; //made this a string instead of boolean for less hassle

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedLanguageValue = prefs.getString('selectedLanguage');
    final selectedOddsFormatValue = prefs.getString('selectedOddsFormat');
    final selectedNotificationsOptionValue =
        prefs.getString('selectedNotificationsOption');
    final selectedDarkModeEnabledValue =
        prefs.getString('selectedDarkModeEnabled');

    if (selectedLanguageValue != null) {
      setState(() {
        selectedLanguage = selectedLanguageValue;
        selectedOddsFormat = selectedOddsFormatValue!;
        selectedNotificationsOption = selectedNotificationsOptionValue!;
        selectedDarkModeEnabled = selectedDarkModeEnabledValue!;
      });
    }
  }

  Future<void> _showDialog(
    String alertTitle,
    String sharedPrefsKeyName,
    List<String> choices,
  ) async {
    final selectedValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                for (String choice in choices)
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop(choice);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString(sharedPrefsKeyName, choice);
                    },
                    child: Text(choice),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedValue != null) {
      setState(() {
        switch (sharedPrefsKeyName) {
          case 'selectedLanguage':
            selectedLanguage = selectedValue;
          case 'selectedOddsFormat':
            selectedOddsFormat = selectedValue;
          case 'selectedNotificationsOption':
            selectedNotificationsOption = selectedValue;
          case 'selectedDarkModeEnabled':
            selectedDarkModeEnabled = selectedValue;
          default:
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child: Column(
        children: [
          topBar(
            context,
            'lib/assets/images/go-back.svg',
            () {
              Navigator.pop(context);
            },
          ),
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              ListTile(
                title: const Text('Language'),
                subtitle: Text(selectedLanguage),
                onTap: () {
                  _showDialog(
                    "Select language:", // alertTitle
                    'selectedLanguage', // sharedPrefsKeyName
                    ['English', 'Polish', 'German', 'Russian'], // choices
                  );
                },
              ),
              ListTile(
                title: const Text('Dark Mode'),
                subtitle: Text(selectedDarkModeEnabled),
                onTap: () {
                  _showDialog(
                    "Dark mode: ",
                    'selectedDarkModeEnabled',
                    ['on', 'off'],
                  );
                },
              ),
              ListTile(
                title: const Text('Betting Odds Format'),
                subtitle: Text(selectedOddsFormat),
                onTap: () {
                  _showDialog(
                    "Select odds format:",
                    'selectedOddsFormat',
                    ['Decimal', 'Fractional', 'American'],
                  );
                },
              ),
              ListTile(
                title: const Text('Notifications'),
                subtitle: Text(selectedNotificationsOption),
                onTap: () {
                  _showDialog(
                    "Select notification option:",
                    'selectedNotificationsOption',
                    [
                      'EndOfEveryMatch',
                      'Idk',
                      'Any',
                      'Other',
                      'Never',
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
