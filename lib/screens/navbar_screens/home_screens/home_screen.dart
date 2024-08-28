import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void goHome2(BuildContext context) {
    GoRouter.of(context).go('/home/2');
  }

  Future<void> logOutUser() async {
    Provider.of<UserDataProvider>(context, listen: false).userData = null;
    await FirebaseAuth.instance.signOut();
  }

  Widget buildSection(
    String title,
    double usableWidth,
    double cardHeight,
    double cardWidth,
    List<Widget> widgets,
    {String? description,
    bool vertical=false,
    bool hidden=false,}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        nunitoText(title, 18, FontWeight.bold, Colors.black),
        if (description != null) nunitoText(description, 14, FontWeight.normal, Colors.grey) else const SizedBox(),
        const SizedBox(
          height: 8,
        ),
        Stack(
          children: [
            if (vertical) 
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widgets,
                ),
              )
            else 
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: widgets,),
              ),
            if (hidden)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                  width: usableWidth,
                  height: cardHeight,
                  child: Center(
                    child: nunitoText('Coming soon', 18, FontWeight.bold, Colors.white),
                  ),
                ),
              ),
          ],
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final usableWidth = MediaQuery.of(context).size.width * 0.9;
    final cardWidth = usableWidth * 0.45;
    final cardHeight = MediaQuery.of(context).size.height * 0.15;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: nunitoText('Home', 26, FontWeight.bold, Colors.black),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: usableWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSection(
                  "Invites",
                  usableWidth, //this has no impact?
                  cardHeight,
                  cardWidth,
                  [
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                  ],
                  hidden: true,
                ),
            
                buildSection(
                  "Game modes",
                  usableWidth,
                  cardHeight,
                  cardWidth,
                  [
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                  ],
                  hidden: true,
                  description: "Checkout other game modes we have on offer",
                ),
                buildSection(
                  "Popular",
                  usableWidth,
                  cardHeight,
                  cardWidth,
                  [
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: const Card(),
                    ),
                  ],
                  description: "Most popular events today",
                  vertical: true
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
