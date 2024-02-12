import 'package:app/components/auth_screens/button.dart';
import 'package:app/components/auth_screens/image_tile.dart';
import 'package:app/components/auth_screens/text_field.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/utils/functions.dart' as utils;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? toggleScreen;
  const RegisterScreen({super.key, required this.toggleScreen});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> registerUser() async {
    final bool registerSuccessful = await tryRegisterUser();
    // can do smth here, but if want to use [context],
    // need to find a way for it to be mounted
  }

  Future<bool> tryRegisterUser() async {
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
      if (passwordController.text.length < 8 ||
          passwordController.text.length > 16) {
        utils.showSnackbarMessage(
          "Password must be between 8 and 16 characters.",
          context,
        );
        if (mounted) {
          Navigator.pop(context);
        }
      }
      if (passwordController.text != confirmPasswordController.text) {
        utils.showSnackbarMessage("Passwords do not match.", context);
        if (mounted) {
          Navigator.pop(context);
        }
      }
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          )
          .then(
            (result) => result.user!.updateDisplayName(emailController.text),
          );

      return true;
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }
      if (e.code == 'user-not-found') {
        if (mounted) {
          utils.showSnackbarMessage(
            "No user found for that email.",
            context,
          );
        }
      } else if (e.code == 'wrong-password') {
        if (mounted) {
          utils.showSnackbarMessage(
            "E-mail and password do not match.",
            context,
          );
        }
      }
    }
    if (mounted) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
    if (mounted) {
      Provider.of<UserDataProvider>(context, listen: false)
          .updateUserData(null);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Icon(
                  Icons.app_registration_rounded,
                  size: 135,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.8),
                ),
                const SizedBox(height: 20),
                nunitoText(
                  "Let's get started:",
                  25,
                  FontWeight.normal,
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
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
                const SizedBox(height: 15),
                AuthTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 15),
                MyButton(text: "Sign up", onTap: registerUser),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/assets/images/google.png',
                      imageHeight: 30,
                    ),
                    //TODO: Add Facebook registration
                    // const SizedBox(width: 30),
                    // ImageTile(
                    //   // onTap: () => AuthService().signInWithFacebook(),
                    //   onTap: () {},
                    //   imagePath: 'lib/assets/images/facebook.png',
                    //   imageHeight: 30,
                    // ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    nunitoText(
                      "Already have an account? ",
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
                      child: Text(
                        'Log in now',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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
