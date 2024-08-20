import 'package:app/components/auth_screens/button.dart';
import 'package:app/components/auth_screens/image_tile.dart';
import 'package:app/components/auth_screens/text_field.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/utils/functions.dart' as utils;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool isLoading = false;

  Future<void> registerUser(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    if (mounted) {
      // it might be that we are redirected to another screen before this is called,
      // that's why we need to check if it's mounted
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> tryRegisterUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      if (passwordController.text.length < 8 ||
          passwordController.text.length > 16) {
        utils.showSnackbarMessage(
            "Password must be between 8 and 16 characters.", context,);
        return false;
      }
      if (passwordController.text != confirmPasswordController.text) {
        utils.showSnackbarMessage("Passwords do not match.", context);
        return false;
      }
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((result) {
        result.user!.updateDisplayName(emailController.text);
      });
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'weak-password') {
        errorMessage = "Password is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already in use by another account.";
      } else {
        errorMessage = "An error occurred: ${e.code}";
      }
      utils.showSnackbarMessage(errorMessage, context);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
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
                      .onSurface
                      .withOpacity(0.8),
                ),
                const SizedBox(height: 20),
                nunitoText(
                  "Let's get started:",
                  25,
                  FontWeight.normal,
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
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
                MyButton(
                  text: "Sign up",
                  onTap: () => registerUser(context),
                  isClickable: !isLoading,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
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
                          .onSurface
                          .withOpacity(0.8),
                    ),
                    Expanded(
                      child: Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
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
                          .onSurface
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
