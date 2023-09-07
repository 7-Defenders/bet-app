import 'package:app/components/button.dart';
import 'package:app/components/image_tile.dart';
import 'package:app/components/text_field.dart';
import 'package:app/utils.dart' as utils;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        utils.showSnackbarMessage("No user found for that email.", context);
      } else if (e.code == 'wrong-password') {
        utils.showSnackbarMessage("E-mail and password do not match.", context);
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
                Icon(Icons.login, size: 135, color: Colors.grey[800]),
                const SizedBox(height: 20),
                Text(
                  'Welcome back!',
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                MyButton(text: "Log In", onTap: logInUser),
                const SizedBox(height: 35),
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
                const SizedBox(height: 35),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageTile(
                      imagePath: 'lib/assets/images/google.png',
                      imageHeight: 30,
                    ),
                    SizedBox(width: 30),
                    ImageTile(
                      imagePath: 'lib/assets/images/facebook.png',
                      imageHeight: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.toggleScreen,
                      child: Text(
                        'Register now',
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
