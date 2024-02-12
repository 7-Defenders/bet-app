class UserData {
  String? displayName;
  String? email;
  String? photoURL;
  bool emailVerified;
  String uid;

  UserData({
    this.displayName,
    required this.email,
    this.photoURL,
    required this.emailVerified,
    required this.uid,
  });

  UserData get userData => UserData(
        displayName: displayName,
        email: email,
        photoURL: photoURL,
        emailVerified: emailVerified,
        uid: uid,
      );

  set userData(UserData userData) => UserData(
        displayName: userData.displayName,
        email: userData.email,
        photoURL: userData.photoURL,
        emailVerified: userData.emailVerified,
        uid: userData.uid,
      );
}
