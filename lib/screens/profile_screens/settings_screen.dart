import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

Builder buildOptions() {
  return Builder(
    builder: (context) {
      return ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'App Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // ListTile(
          //   title: const Text('Language'),
          //   subtitle: const Text('Change the language of the app'),
          //   trailing: DropdownButton<String>(
          //     value: 'English',
          //     items:
          //         <String>['English', 'Spanish', 'French'].map((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //     onChanged: (_) {},
          //   ),
          // ),
          ListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable/Disable dark mode'),
            trailing: Switch(
              value: Provider.of<ThemeModeProvider>(context).themeMode ==
                  ThemeMode.dark,
              onChanged: (value) {
                Provider.of<ThemeModeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Notification Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          CheckboxListTile(
            title: const Text('Won Bet'),
            subtitle: const Text('Receive notifications for won bets'),
            value: false,
            onChanged: (bool? value) {},
          ),
          CheckboxListTile(
            title: const Text('League Events'),
            subtitle: const Text('Receive notifications for league events'),
            value: false,
            onChanged: (bool? value) {},
          ),
        ],
      );
    },
  );
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        56,
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        'Settings',
        null,
      ),
      body: buildOptions(),
    );
  }
}
