import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    print("hello");
    debugPrint("hello");
    // first, clear any existing sessions
    await GoogleSignIn().signOut();
    // open google sign in popup
    log('opening popup', level: 500);
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // wait for popup to close and get user token
    log('popup closed', level: 500);
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    debugPrint('id token: ${googleAuth.idToken}');
    debugPrint('access token: ${googleAuth.accessToken}');
    log('id token: ${googleAuth.idToken}', level: 500);
    log('access token: ${googleAuth.accessToken}', level: 500);
    // get credentials from token
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

//   Future<UserCredential> signInWithFacebook() async {
//   // Trigger the sign-in flow
//   final loginResult = await FacebookAuth.instance.login();

//   // Create a credential from the access token
//   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

//   // Once signed in, return the UserCredential
//   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
// }
}
