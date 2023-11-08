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
    final selectedOddsFormatValue = prefs.getString('selectedOddsFormat');
    final selectedNotificationsOptionValue = prefs.getString('selectedNotificationsOption');

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop(choice);
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString(sharedPrefsKeyName, choice);
                      },
                      child: nunitoText(choice, 5*widget.vw, FontWeight.normal, Theme.of(context).colorScheme.onBackground),
                    ),
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
            2.5*widget.vh,
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
          title: nunitoText("Betting odds format", 4*widget.vw, FontWeight.bold, Theme.of(context).colorScheme.onBackground),
          subtitle: nunitoText(selectedOddsFormat, 3.5*widget.vw, FontWeight.normal, Theme.of(context).colorScheme.onBackground),
          onTap: () {
            _showDialog(
              "Select odds format:",
              'selectedOddsFormat',
              ['Decimal', 'Fractional', 'American'],
            );
          },
        ),
        ListTile(
          // title: Text('Notifications'),
          title: nunitoText("Notifications", 4*widget.vw, FontWeight.bold, Theme.of(context).colorScheme.onBackground),
          subtitle: nunitoText(selectedNotificationsOption, 3.5*widget.vw, FontWeight.normal, Theme.of(context).colorScheme.onBackground),
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
