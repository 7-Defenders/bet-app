import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    // first, clear any existing sessions
    await GoogleSignIn().signOut();
    // open google sign in popup
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // wait for popup to close and get user token
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
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
