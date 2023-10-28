import 'package:app/screens/auth_screens/login_screen.dart';
import 'package:app/screens/auth_screens/register_screen.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  bool showLoginScreen = true;

  void toggleScreen() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LogInScreen(
        toggleScreen: toggleScreen,
      );
    } else {
      return RegisterScreen(
        toggleScreen: toggleScreen,
      );
    } 
  }
}
