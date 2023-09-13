import 'package:app/components/button.dart';
import 'package:app/components/image_tile.dart';
import 'package:app/components/text_field.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/utils.dart' as utils;
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

  Future<void> registerUser() async {
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
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        utils.showSnackbarMessage("Passwords do not match.", context);
        return;
      }
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (context.mounted) {
          utils.showSnackbarMessage(
            "No user found for that email.",
            context,
          );
        }
      } else if (e.code == 'wrong-password') {
        if (context.mounted) {
          utils.showSnackbarMessage(
            "E-mail and password do not match.",
            context,
          );
        }
      }
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Icon(
                  Icons.app_registration_rounded,
                  size: 135,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 20),
                Text(
                  "Let's get started:",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                MyTextField(
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
                        color: Colors.grey[700],
                        thickness: 0.5,
                        indent: 20,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      'Or continue with: ',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[700],
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
                    const SizedBox(width: 30),
                    ImageTile(
                      // onTap: () => AuthService().signInWithFacebook(),
                      onTap: () {},
                      imagePath: 'lib/assets/images/facebook.png',
                      imageHeight: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
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
