import 'dart:io';

import 'package:app/components/other/nunito_text.dart';
import 'package:app/globals.dart';
import 'package:app/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    if (Globals.rewardedAd == null) {
      setState(() => Globals.loadRewardedAd());
    }
  }

  void showRewardedAd() {
    if (Globals.rewardedAd == null) {
      Globals.loadRewardedAd();
    }

    if (Globals.rewardedAd != null) {
      Globals.rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          Globals.rewardedAd!.dispose();
          setState(() => Globals.loadRewardedAd());
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          Globals.rewardedAd!.dispose();
          setState(() => Globals.loadRewardedAd());
        },
      );

      if (Platform.isAndroid) {
        Globals.rewardedAd!.setImmersiveMode(true);
      }
      Globals.rewardedAd!.show(
        onUserEarnedReward: (ad, reward) async {
          // awarding coins

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: nunitoText(
                '100 coins were awarded',
                16,
                FontWeight.bold,
                Theme.of(context).colorScheme.primary,
              ),
            ),
          );
          Globals.rewardedAd = null;
          Globals.loadRewardedAd();
        },
      );

    }
  }

  Widget buildSection(
    String title,
    String description,
    double usableWidth,
    double cardHeight,
    double cardWidth,
    String type,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        nunitoText(title, 18, FontWeight.bold, Colors.black),
        nunitoText(description, 14, FontWeight.normal, Colors.grey),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: cardHeight,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Cosmetics')
                .where('type', isEqualTo: type)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              return ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  final Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                    child: GestureDetector(
                      onTap: () => showPurchasePopup(
                        context,
                        Item(
                          id: data['id'] as String,
                          name: data['name'] as String,
                          price: data['price'] as int,
                          link: data['link'] as String,
                          type: ItemType.values.firstWhere(
                            (e) => e.toString() == 'ItemType.$type',
                          ),
                        ),
                      ),
                      child: Card(
                        elevation: 5,
                        surfaceTintColor: Colors.white,
                        child: SizedBox(
                          width: cardWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              nunitoText(
                                data['name'] as String,
                                16,
                                FontWeight.normal,
                                Colors.black,
                              ),
                              SvgPicture.network(
                                data['link'] as String,
                                width: cardWidth * 0.5,
                                height: cardHeight * .5,
                              ),
                              nunitoText(
                                'Price: ${data['price']}',
                                14,
                                FontWeight.normal,
                                Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final usableWidth = MediaQuery.of(context).size.width * 0.9;
    final cardWidth = usableWidth * 0.4;
    final cardHeight = MediaQuery.of(context).size.height * 0.25;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: nunitoText('Shop', 26, FontWeight.bold, Colors.black),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // FIRST SECTION - COINS
              SizedBox(
                width: usableWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    nunitoText("Bet coins", 18, FontWeight.bold, Colors.black),
                    nunitoText("Get free coins or buy coin multipliers", 14,
                        FontWeight.normal, Colors.grey,),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: cardHeight,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(usableWidth / 18, 8, 8, 8),
                      child: Card(
                        elevation: 5,
                        surfaceTintColor: Colors.white,
                        child: SizedBox(
                          width: cardWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: cardWidth * 0.8,
                                child: nunitoText(
                                    'Watch an ad to get 100 coins',
                                    14,
                                    FontWeight.normal,
                                    Colors.black,
                                    textAlign: TextAlign.center,),
                              ),
                              IconButton(
                                onPressed: () => showRewardedAd(),
                                highlightColor:
                                    const Color.fromARGB(255, 255, 187, 85),
                                color: Theme.of(context).colorScheme.primary,
                                icon: Icon(
                                  Icons.videocam,
                                  size: cardHeight * .5,
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

              // Padding(
              //   //! BRUH
              //   padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              //   child: buildSection(
              //     "Profile backgrounds",
              //     "Show off with you favorite background",
              //     usableWidth, //this has no impact?
              //     cardHeight,
              //     cardWidth,
              //     "background",
              //   ),
              // ),
              buildSection(
                "Profile backgrounds",
                "Show off with you favorite background",
                usableWidth, //this has no impact?
                cardHeight,
                cardWidth,
                "background",
              ),

              buildSection(
                "Jerseys",
                "Get a beautiful jersey to present your name",
                usableWidth,
                cardHeight,
                cardWidth,
                "tshirt",
              ),
              buildSection(
                "Profile frames",
                "Enhance your profile with a stylish frame",
                usableWidth,
                cardHeight,
                cardWidth,
                "frame",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
