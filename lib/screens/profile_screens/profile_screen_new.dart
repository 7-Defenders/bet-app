import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreenNew extends StatefulWidget {
  // if this is null, profile of current user will be shown
  final String? uid;

  const ProfileScreenNew({
    super.key,
    required this.uid,
  });

  static const List<Widget> profileOptions = <Widget>[
    ListTile(
      leading: Icon(Icons.history),
      title: Text("History"),
    ),
    ListTile(
      leading: Icon(Icons.settings),
      title: Text("Settings"),
    ),
    ListTile(
      leading: Icon(Icons.person),
      title: Text("Profile settings"),
    ),
    ListTile(
      leading: Icon(Icons.notifications),
      title: Text("Notifications"),
    ),
  ];

  @override
  State<ProfileScreenNew> createState() => _ProfileScreenNewState();
}

class _ProfileScreenNewState extends State<ProfileScreenNew> {
  UserData? userData;
  late bool isCurrentUser;

  // on page load, we need to determine if the page is of the current user or not:
  @override
  void initState() {
    super.initState();

    if ((widget.uid != null) &&
        (widget.uid != FirebaseAuth.instance.currentUser!.uid)) {
      // the page is not of the current user. set flag and fetch the user data.
      isCurrentUser = false;
      Provider.of<UserDataProvider>(context, listen: false)
          .requestUserData(widget.uid!)
          .then((value) => userData = value);
    } else {
      // the page is of the current user. set flag and use the user data from the provider
      isCurrentUser = true;
      userData = Provider.of<UserDataProvider>(context, listen: false).userData;
    }
  }

  Widget buildProfileScreen() {
    return isCurrentUser ? buildCurrentUserProfile() : buildOtherUserProfile();
  }

  Widget buildCurrentUserProfile() {
    return Column(
      children: [
        const Text("CURRENT USER PROFILE"),
        Text('Display Name: ${userData!.displayName ?? 'N/A'}'),
        Text('Email: ${userData!.email ?? 'N/A'}'),
        Text('Photo URL: ${userData!.photoURL ?? 'N/A'}'),
        Text('Email Verified: ${userData!.emailVerified ? 'Yes' : 'No'}'),
        Text('UID: ${userData!.uid}'),
      ],
    );
  }

  Widget buildOtherUserProfile() {
    return Column(
      children: [
        const Text("OTHER USER PROFILE"),
        Text('Display Name: ${userData!.displayName ?? 'N/A'}'),
        Text('Email: ${userData!.email ?? 'N/A'}'),
        Text('Photo URL: ${userData!.photoURL ?? 'N/A'}'),
        Text('Email Verified: ${userData!.emailVerified ? 'Yes' : 'No'}'),
        Text('UID: ${userData!.uid}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> logOutUser() async {
      Provider.of<UserDataProvider>(context, listen: false).userData = null;
      await FirebaseAuth.instance.signOut();
    }

    Container buildProfileArea() {
      return Container(
        decoration: const BoxDecoration(
          //! in firestore add profile_bg field so it can
          //! be displayed here. store it in userData!
          color: Color.fromARGB(255, 255, 186, 74),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      );
    }

    ListView buildListView(List<Widget> widgets) {
      return ListView(
        children: widgets,
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          // body: Column(
          //   children: [
          //     SizedBox(
          //       height: constraints.maxHeight * 0.5,
          //       child: buildProfileArea(),
          //     ),
          //     Expanded(
          //       child: buildListView(ProfileScreenNew.profileOptions),
          //     ),
          //   ],
          // ),
          body: buildProfileScreen(),
        );
      },
    );
  }
}
