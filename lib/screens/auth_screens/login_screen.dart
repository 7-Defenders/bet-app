import 'package:app/components/auth_screens/button.dart';
import 'package:app/components/auth_screens/image_tile.dart';
import 'package:app/components/auth_screens/text_field.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/utils/functions.dart' as utils;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  final Function()? toggleScreen;
  const LogInScreen({super.key, required this.toggleScreen});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future<void> logInUser() async {
    final bool loginSuccessful = await tryLogInUser();
    // can do smth here, but if want to use [context],
    // need to find a way for it to be mounted
  }

  Future<bool> tryLogInUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (context.mounted) {
          Navigator.pop(context);
          utils.showSnackbarMessage(
            "No user found for given email.",
            context,
          );
        }
      } else if (e.code == 'wrong-password') {
        if (context.mounted) {
          Navigator.pop(context);
          utils.showSnackbarMessage(
            "E-mail and password do not match.",
            context,
          );
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          utils.showSnackbarMessage(
            "error: ${e.code} LINE 66",
            context,
          );
        }
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Icon(
                  Icons.login,
                  size: 135,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.8),
                ),
                const SizedBox(height: 20),
                nunitoText(
                  'Welcome back!',
                  25,
                  FontWeight.normal,
                  Theme.of(context).colorScheme.onBackground,
                ),
                const SizedBox(height: 25),
                AuthTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                AuthTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      nunitoText(
                        'Forgot Password?',
                        16,
                        FontWeight.normal,
                        Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(text: "Log In", onTap: logInUser),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.8),
                        thickness: 0.5,
                        indent: 20,
                        endIndent: 10,
                      ),
                    ),
                    nunitoText(
                      'Or continue with: ',
                      13,
                      FontWeight.normal,
                      Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.8),
                    ),
                    Expanded(
                      child: Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.8),
                        thickness: 0.5,
                        indent: 10,
                        endIndent: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/assets/images/google.png',
                      imageHeight: 30,
                    ),
                    //TODO: Implement Facebook login
                    // const SizedBox(width: 30),
                    // ImageTile(
                    //   // onTap: () => AuthService().signInWithFacebook(),
                    //   onTap: () {},
                    //   imagePath: 'lib/assets/images/facebook.png',
                    //   imageHeight: 30,
                    // ),
                  ],
                ),
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    nunitoText(
                      "Not a member? ",
                      15,
                      FontWeight.normal,
                      Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.8),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.toggleScreen,
                      child: nunitoText(
                        'Register now',
                        15,
                        FontWeight.bold,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
