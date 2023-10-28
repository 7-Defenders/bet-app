import 'package:app/assets/translations.dart';
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

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedLanguageValue = prefs.getString('selectedLanguage');
    final selectedOddsFormatValue = prefs.getString('selectedOddsFormat');
    final selectedNotificationsOptionValue = prefs.getString('selectedNotificationsOption');
    final selectedDarkModeEnabledValue = prefs.getString('selectedDarkModeEnabled');

    if (selectedLanguageValue != null) {
      setState(() {
        selectedLanguage = selectedLanguageValue;
      });
    }

    if (selectedOddsFormatValue != null) {
      setState(() {
        selectedOddsFormat = selectedOddsFormatValue;
      });
    }

    if (selectedNotificationsOptionValue != null) {
      setState(() {
        selectedNotificationsOption = selectedNotificationsOptionValue;
      });
    }

    if (selectedDarkModeEnabledValue != null) {
      setState(() {
        selectedDarkModeEnabled = selectedDarkModeEnabledValue;
      });
    }

    setState(() {
      loading = false;
    });
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
                for (final String choice in choices)
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop(choice);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString(sharedPrefsKeyName, choice);
                    },
                    child: Text(translate(choice, selectedLanguage)),
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
            // topBar(
            //   context,
            //   'lib/assets/images/go-back.svg',
            //   () {
            //     Navigator.pop(context);
            //   },
            // ),
            FutureBuilder<void>(
              future: Future.delayed(Duration.zero).then((value) => loading),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return buildSettingsList();
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsList() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        ListTile(
          title: Text(translate("Language", selectedLanguage)),
          subtitle: Text(translate(selectedLanguage, selectedLanguage)),
          onTap: () {
            _showDialog(
              translate("Select language:", selectedLanguage), // alertTitle
              'selectedLanguage', // sharedPrefsKeyName
              ['English', 'Polish', 'German', 'Russian'], // choices
            );
          },
        ),
        ListTile(
          title: Text(translate("Dark Mode", selectedLanguage)),
          subtitle: Text(translate(selectedDarkModeEnabled, selectedLanguage)),
          onTap: () {
            _showDialog(
              translate("Dark mode:", selectedLanguage),
              'selectedDarkModeEnabled',
              ['on', 'off'],
            );
          },
        ),
        ListTile(
          title: Text(translate('Betting Odds Format', selectedLanguage)),
          subtitle: Text(translate(selectedOddsFormat, selectedLanguage)),
          onTap: () {
            _showDialog(
              translate("Select odds format:", selectedLanguage),
              'selectedOddsFormat',
              ['Decimal', 'Fractional', 'American'],
            );
          },
        ),
        ListTile(
          title: Text(translate('Notifications', selectedLanguage)),
          subtitle: Text(translate(selectedNotificationsOption, selectedLanguage)),
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
    );
  }
}
