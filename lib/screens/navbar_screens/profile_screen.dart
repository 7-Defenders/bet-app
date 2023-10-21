import 'dart:io';

import 'package:app/assets/translations.dart';
import 'package:app/components/text_input_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {

  String selectedLanguage = 'English';
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  String? displayName;
  String? email;
  String? photoURL;
  bool? emailVerified;
  String? uid;

  @override
  void initState() {
    super.initState();
    getSelectedLanguage().then((language) {
      setState(() {
        selectedLanguage = language;
      });
    });
    getUserData();
  }

  Future<void> getUserData() async {
    displayName = user?.displayName;
    email = user?.email;
    photoURL = user?.photoURL;
    emailVerified = user?.emailVerified;
    uid = user?.uid;
    print('User Data: $displayName, $email, $photoURL, $emailVerified, $uid');
  }

  Future<String> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    return selectedLanguage;
  }

  Future<void> logOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> changeProfilePicture() async {
    // get photo from gallery
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (image == null) return;

    // upload to firebase storage
    final ref = storage.ref().child('profile_pictures/${user!.uid}');
    final uploadTask = ref.putFile(
      File(image.path),
    );
    final snapshot = await uploadTask.whenComplete(() => null);

    // get download url and update user profile
    final downloadURL = await snapshot.ref.getDownloadURL();
    await user!.updatePhotoURL(downloadURL);

    setState(() {});
  }

  Future<void> changeDisplayName() async {
    await showDialog<String>(
      context: context,
      builder: (context) => TextInputDialog(
        vw: MediaQuery.of(context).size.width / 100,
        vh: MediaQuery.of(context).size.height / 100,
        title: translate('Change username', selectedLanguage),
        subtext: translate('You can change your username once every 30 days.', selectedLanguage),
        hintText: translate('Enter new username', selectedLanguage),
        validator: (value) {
          if (value == null || value.length < 3) {
            return translate('Username must be minimum 3 characters long', selectedLanguage);
          }
          return null;
        },
        onSaved: (value) async {
          print(value);
          await user!.updateDisplayName(value);
          getUserData();
        },
      ),
    );
    getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final double vh = MediaQuery.of(context).size.height/100;
    final double vw = MediaQuery.of(context).size.width/100;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            // color: Color.fromARGB(255, 93, 183, 172),
            color: Color.fromARGB(255, 93, 100, 255),
          ),
        ),
        Positioned(
          top: 26*vh,
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
                      padding: EdgeInsets.fromLTRB(0,12*vh, 0, 0),
                      child: Column(
                        children: [ //TODO: there are 2 containers with futurebuilders - create a widget for them in assets for clean codes sake
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 1 * vh),
                            child: Text(
                              displayName!,
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  //grayish black
                                  color: Color.fromARGB(240, 40, 40, 40),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5*vh),
                            child: Text(
                              email!,
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  //grayish black
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 2*vh),
                            child: GestureDetector(
                              onTap: logOutUser,
                              child: Container(
                                width: 85*vw,
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
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(240, 40, 40, 40),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 2*vh),
                            child: GestureDetector(
                              onTap: changeDisplayName,
                              child: Container(
                                width: 85*vw,
                                height: 8*vh,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromARGB(255, 254,255,254),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(5*vw, 0, 5*vw, 0),
                                      child: const Icon(FontAwesomeIcons.penToSquare, color: Color.fromARGB(255, 93, 100, 255)),
                                    ),
                                    Text(
                                      translate('Change username', selectedLanguage),
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(240, 40, 40, 40),
                                      ),
                                    ),
                                  ],
                                ),
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
          top: 17*vh,
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
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: photoURL != ""
                      ? Image.network(photoURL!).image
                      : Image.asset('lib/assets/images/default_profile_picture.png').image,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 31*vh,
          left: 31*vw,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: changeProfilePicture,
              child: Container(
                width: 6*vh,
                height: 5.5*vh,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 254,255,254),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Color.fromARGB(255, 93, 100, 255),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
