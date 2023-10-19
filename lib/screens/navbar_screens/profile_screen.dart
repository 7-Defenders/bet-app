import 'package:app/assets/translations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  String selectedLanguage = 'English';
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getSelectedLanguage().then((language) {
      setState(() {
        selectedLanguage = language;
      });
    });
  }

  Future<String> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    print(selectedLanguage);
    return selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {

    final double vh = MediaQuery.of(context).size.height/100;
    final double vw = MediaQuery.of(context).size.width/100;

    Future<void> logOutUser() async {
      await FirebaseAuth.instance.signOut();
    }

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            // color: Color.fromARGB(255, 93, 183, 172),
            color: Color.fromARGB(255, 93, 100, 255),
          ),
        ),
        Positioned(
          top: 26*vh, // Adjust the value as needed
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 250,250,250),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0,15*vh, 0, 0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: logOutUser,
                            child: Container(
                              width: 70*vw,
                              height: 8*vh,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 254,255,254),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(5*vw, 0, 5*vw, 0),
                                    child: const Icon(Icons.logout, color: Color.fromARGB(255, 93, 100, 255)),
                                  ),
                                  Text(
                                    translate('Log Out', selectedLanguage),
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        //grayish black
                                        color: Color.fromARGB(240, 40, 40, 40),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 17*vh, // Adjust the value as needed
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 19*vh,
              height: 19*vh,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(width: 10, color: const Color.fromARGB(255, 254,255,254)),
                // border: Border.all(width: 5, color: Colors.white),
                image: const DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('lib/assets/images/cat.jpg'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
