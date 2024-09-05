import 'package:app/components/history_screen/history_bet_widget.dart';
import 'package:app/components/profile_screen/profile_area.dart';
import 'package:app/globals.dart';
import 'package:app/models/bet.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreenNew extends StatefulWidget {
  // if this is null, profile of current user will be shown
  final String? uid;

  const ProfileScreenNew({
    super.key,
    required this.uid,
  });

  @override
  State<ProfileScreenNew> createState() => _ProfileScreenNewState();
}

class _ProfileScreenNewState extends State<ProfileScreenNew> {
  UserData? userData;
  List<Bet> betList = [];
  bool betsDisplayed = false;
  late bool isCurrentUser;

  late List<Widget> profileOptions = <Widget>[
    ListTile(
      leading: Icon(
        Icons.history,
        color: Theme.of(context).iconTheme.color,
        size: Theme.of(context).iconTheme.size,
      ),
      title: Text(
        "Your Bet history",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      onTap: () {
        // GoRouter.of(context).go('/profile/history')
        setState(() => betsDisplayed = true);
      },
    ),
    ListTile(
      leading: Icon(
        Icons.settings,
        color: Theme.of(context).iconTheme.color,
        size: Theme.of(context).iconTheme.size,
      ),
      title: Text(
        "App Settings",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      onTap: () => {GoRouter.of(context).go('/profile/settings')},
    ),
    ListTile(
      leading: Icon(
        Icons.person,
        color: Theme.of(context).iconTheme.color,
        size: Theme.of(context).iconTheme.size,
      ),
      title: Text(
        "Profile Settings",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      onTap: () => {GoRouter.of(context).go('/profile/profile_settings')},
    ),
    ListTile(
      leading: Icon(
        Icons.palette,
        color: Theme.of(context).iconTheme.color,
        size: Theme.of(context).iconTheme.size,
      ),
      title: Text(
        "Cosmetics",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      onTap: () => {GoRouter.of(context).go('/profile/cosmetics')},
    ),
    ListTile(
      leading: Icon(
        Icons.check,
        color: Theme.of(context).iconTheme.color,
        size: Theme.of(context).iconTheme.size,
      ),
      title: Text(
        "Achievements",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      onTap: () => {GoRouter.of(context).go('/profile/achievements')},
    ),
    const Divider(
      color: Colors.black,
    ),
    ListTile(
      leading: Icon(
        Icons.logout,
        color: Theme.of(context).iconTheme.color,
        size: Theme.of(context).iconTheme.size,
      ),
      title: Text(
        "Log out",
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.red,
            ),
      ),
      onTap: logOutUser,
    ),
  ];

  Future<void> logOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  // on page load, we need to determine if the page is of the current user or not:
  @override
  void initState() {
    super.initState();

    if ((widget.uid != null) &&
        (widget.uid != FirebaseAuth.instance.currentUser!.uid)) {
      isCurrentUser = false;
      Provider.of<UserDataProvider>(context, listen: false)
          .requestUserData(widget.uid!)
          .then((value) => userData = value);
    } else {
      debugPrint('User IS current user');
      isCurrentUser = true;
      userData = Provider.of<UserDataProvider>(context, listen: false).userData;
    }
  }

  // @override
  // void didChangeDependencies() {
  //   // this is actually goated
  //   // called right after initState - you cant listen to provider in initState
  //   super.didChangeDependencies();
  //   if (isCurrentUser) {
  //     userData = Provider.of<UserDataProvider>(context).userData;
  //   }
  // }

  Widget buildProfileScreen({bool backArrow = false}) {
    final UserData? userData = Provider.of<UserDataProvider>(context).userData;
    if (userData == null) {
      FirebaseAuth.instance.signOut();
    }
    return isCurrentUser
        ? buildCurrentUserProfile(userData!, backArrow: backArrow)
        : buildOtherUserProfile(userData!);
  }

    Future<void> getUserHistory() async {
    // debugPrint(widget.userID);
    betList.clear();

    final dateTime = DateTime.now().subtract(const Duration(days: 7)).toUtc();
    final day = DateTime.now().subtract(const Duration(days: 1)).toUtc();
    final uriWeek = 'https://flask-vhn3gxevdq-ew.a.run.app/v1/bets/${widget.uid}?startDate=${dateTime.year}/${dateTime.month}/${dateTime.day}/${dateTime.hour}';
    final uriDay = 'https://flask-vhn3gxevdq-ew.a.run.app/v1/bets/${widget.uid}?startDate=${day.year}/${day.month}/${day.day}/${day.hour}';

    final response = Globals.shouldCall(uriWeek) ? await Globals.performCall(uriWeek) : Globals.hasNewBet ? await Globals.loadMoreBets(uriDay) : Globals.getBets();

    betList = betFromJson(response);
    betList.sort(
      (a,b) {
        if (a.game == null){
          return 1;
        }
        if (b.game == null){
          return 0;
        }

        final aDate = a.game!.date??= DateTime(2000,);
        final bDate = b.game!.date??= DateTime(2000,);

        return bDate.compareTo(aDate);
      }
    );
  }

  Widget buildCurrentUserProfile(UserData userData,{bool backArrow = false}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: constraints.maxHeight * 0.4,
                child: buildProfileArea(userData, context, backArrow: backArrow, onBackArrowPressed: (context) => setState(() => betsDisplayed = false)),
              ),
              Expanded(
                child: betsDisplayed ? ListView(
                  children: betList
                      .map((bet) => HistoryBetWidget(bet: bet))
                      .toList(),
                ) : buildOptionsList(profileOptions),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildOtherUserProfile(UserData userData) {
    return Column(
      children: [
        const Text("OTHER USER PROFILE"),
        Text('Display Name: ${userData.displayName ?? 'N/A'}'),
        Text('Email: ${userData.email ?? 'N/A'}'),
        Text('Photo URL: ${userData.photoURL ?? 'N/A'}'),
        Text('Email Verified: ${userData.emailVerified ? 'Yes' : 'No'}'),
        Text('UID: ${userData.uid}'),
      ],
    );
  }

  LayoutBuilder buildOptionsList(List<Widget> widgets) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          padding: EdgeInsets.all(constraints.maxWidth * 0.02),
          children: widgets,
        );
      },
    );
  }

  Padding buildUserFactsWidget(BoxConstraints constraints, UserData userData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: constraints.maxHeight * 0.04),
      child: Container(
        padding: EdgeInsets.all(constraints.maxHeight * 0.01),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: const Color.fromARGB(255, 255, 186, 75),
          border: Border.all(
            color: Colors.white,
            width: constraints.maxHeight * 0.006,
          ),
        ),
        child: ClipRRect(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Verified: ${userData.emailVerified}",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                "Balance: ${userData.balance}",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (betsDisplayed) {
      return FutureBuilder<void>(
        future: getUserHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return buildProfileScreen(backArrow: true);
          } else {
            return Center(
              child: LoadingAnimationWidget.hexagonDots(
                color: Theme.of(context).colorScheme.primary,
                size: 55,
              ),     
            );
          }
        },
      );
    }
    else {
      return buildProfileScreen();
    }
  }
}
