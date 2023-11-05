import 'package:app/components/other/nunito_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsExpansionButton extends StatefulWidget {
  final double vw;
  final double vh;
  final String title;

  const SettingsExpansionButton({
    super.key,
    required this.vw,
    required this.vh,
    required this.title,
  });

  @override
  State<SettingsExpansionButton> createState() => _SettingsExpansionButtonState();
}

class _SettingsExpansionButtonState extends State<SettingsExpansionButton> {
  String selectedLanguage = 'English';
  String selectedOddsFormat = 'Decimal';
  String selectedNotificationsOption = 'EndOfEveryMatch';

  bool loading = true;
  bool isExpanded = false;

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
          default:
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ExpansionTile(
          title: nunitoText(
            widget.title,
            3*widget.vh,
            FontWeight.bold,
            Theme.of(context).colorScheme.onBackground,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<void>(
                future: Future.delayed(Duration.zero).then((value) => loading),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return buildSettingsList();
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSettingsList() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(12.0),
      children: <Widget>[
        ListTile(
          title: Text('Betting Odds Format'),
          subtitle: Text(selectedOddsFormat),
          onTap: () {
            _showDialog(
              ("Select odds format:"),
              'selectedOddsFormat',
              ['Decimal', 'Fractional', 'American'],
            );
          },
        ),
        ListTile(
          title: Text('Notifications'),
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
    );
  }
}
