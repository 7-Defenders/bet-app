import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

ListView buildProfileOptions() {
  return ListView(
    children: <Widget>[],
  );
}

ListView buildOptions() {
  return ListView(
    children: <Widget>[],
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
            GoRouter.of(context).go('/profile');
          },
        ),
        'Settings',
        null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildProfileOptions(),
            const Divider(),
            buildOptions(),
          ],
        ),
      ),
    );
  }
}
