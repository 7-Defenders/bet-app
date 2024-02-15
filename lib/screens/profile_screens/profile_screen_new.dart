import 'package:app/components/other/appbar/balance_widget.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  UserData? userData; //TODO: can this be null?
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
    debugPrint("bg url: ${userData!.bgURL}");
    return isCurrentUser ? buildCurrentUserProfile() : buildOtherUserProfile();
  }

  Widget buildCurrentUserProfile() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: constraints.maxHeight * 0.5,
                child: buildProfileArea(),
              ),
              Expanded(
                child: buildOptionsList(ProfileScreenNew.profileOptions),
              ),
            ],
          ),
        );
      },
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

  ListView buildOptionsList(List<Widget> widgets) {
    return ListView(
      children: widgets,
    );
  }

  Stack buildProfileArea() {
    return Stack(
      children: [
        buildProfileAreaBackground(),
        buildProfileAreaForeground(),
        buildPoints(),
      ],
    );
  }

  ClipRRect buildProfileAreaBackground() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: SvgPicture.network(
        userData!.bgURL!,
        fit: BoxFit.fill,
      ),
    );
  }

  LayoutBuilder buildProfileAreaForeground() {
    // align the profile area widgets accordingly to their parent (proifleArea's) height
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(height: constraints.maxHeight * 0.2),
            Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Align(
                      alignment: const Alignment(0, -0.5),
                      child: SvgPicture.network(
                        userData!.tshirtURL!,
                        height: constraints.maxHeight * 0.5,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: const Alignment(0, 0.5),
                  child: Image.network(
                    userData!.photoURL!,
                    height: constraints.maxHeight * 0.25,
                  ),
                ),
              ],
            ),
            buildUserFactsWidget(),
            SizedBox(height: constraints.maxHeight * 0.1),
          ],
        );
      },
    );
  }

  Positioned buildPoints() {
    //TODO use the already-existing points widget (figure out vw vh 'replacement' first):
    // return Positioned(
    // child: BalanceWidget(),
    // );
    return Positioned(
      child: Container(),
    );
  }

  Container buildUserFactsWidget() {
    return Container();
  }

  Future<void> logOutUser() async {
    Provider.of<UserDataProvider>(context, listen: false).userData = null;
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return buildProfileScreen();
  }
}
