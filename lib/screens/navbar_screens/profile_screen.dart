import 'dart:io';

import 'package:app/assets/translations.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/components/profile_screen/gesture_detector_button.dart';
import 'package:app/components/profile_screen/profile_pic.dart';
import 'package:app/components/profile_screen/text_input_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/profile_screen/settings_popup.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {

  String selectedLanguage = 'English';
  final user = FirebaseAuth.instance.currentUser;
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
    email = user!.email;
    displayName = user!.displayName;
    photoURL = user!.photoURL;
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
    // wait for download url, set photoURL and setState()
    final downloadURL = await snapshot.ref.getDownloadURL();
    await user!.updatePhotoURL(downloadURL);
    photoURL = downloadURL;
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
        // TODO: add a check to see if username is already taken
        onSaved: (value) async {
          await user!.updateDisplayName(value);
          displayName = value;
          setState(() {});
        },
      ),
    );
  }

  Future<void> popupSettings() async {
    await showDialog(
        context: context,
        builder: (context) => SettingsPopup(
          vw: MediaQuery.of(context).size.width / 100,
          vh: MediaQuery.of(context).size.height / 100,
          title: translate('Settings', selectedLanguage),
        ),
    );
    selectedLanguage = await getSelectedLanguage();
    setState(() {
      selectedLanguage = selectedLanguage;
    });
  }


  @override
  Widget build(BuildContext context) {

    final double vh = MediaQuery.of(context).size.height/100;
    final double vw = MediaQuery.of(context).size.width/100;

    return Stack(
      children: [
        // background primary color
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        // white background
        Positioned(
          top: 26*vh,
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0,12*vh, 0, 0),
                      child: Column(
                        children: [
                          // displayName
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 1 * vh),
                            child: nunitoText(displayName!, 50, FontWeight.bold, Theme.of(context).colorScheme.onBackground),
                          ),
                          // email
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5*vh),
                            child: nunitoText(email!, 20, FontWeight.bold, Theme.of(context).colorScheme.tertiary),
                          ),
                          //change username
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 2*vh),
                            child: gestureDetectorButton(FontAwesomeIcons.penToSquare, translate("Change username", selectedLanguage), changeDisplayName, vw, vh, context),
                          ),
                          // navigate to settings
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 2*vh),
                            child: gestureDetectorButton(Icons.settings_outlined, translate("Settings", selectedLanguage), popupSettings, vw, vh, context,),
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
        // log out
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5*vh),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: gestureDetectorButton(Icons.logout, translate("Log Out", selectedLanguage), logOutUser, vw, vh, context),
            ),
          ),
        ),
        Positioned(
          top: 17*vh,
          left: 0,
          right: 0,
          child: Center(
            child: pictureWithBorder(photoURL, vh, context),
          ),
        ),
        Positioned(
          top: 31*vh,
          left: 31*vw,
          right: 0,
          child: smallButton(changeProfilePicture, vw, vh, Icons.camera_alt_outlined, context),
        ),
      ],
    );
  }
}
