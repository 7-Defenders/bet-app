import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    
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

  Future<UserCredential> signInWithFacebook() async {
    // not tested yet whatsoever
    final result = await FirebaseAuth.instance.signInWithPopup(FacebookAuthProvider());
    return result;
  }
}
