import 'package:app/providers/user_data_provider.dart';
import 'package:app/screens/auth_screens/login_screen.dart';
import 'package:app/screens/auth_screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserDataProvider>(context, listen: false).userData = null;
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
