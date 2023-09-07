import 'package:app/components/button.dart';
import 'package:app/components/image_tile.dart';
import 'package:app/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> logInUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Icon(Icons.account_circle, size: 135, color: Colors.grey[800]),
                const SizedBox(height: 20),
                Text('Welcome back!',
                    style: GoogleFonts.poppins(
                        fontSize: 25, color: Colors.grey[700],),),
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
                      Text('Forgot Password?',
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.grey[700],),),
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
                    Text('Or continue with: ',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.grey[700],),),
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
                    Text("Don't have an account? ",
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.grey[700],),),
                    Text('Sign up now',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,),),
                  ],
                ),
              ],
            ),
          ),
        ),);
  }
}
