import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:app/ad_state.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  RewardedAd? _rewardedAd;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    loadRewardedAd();
  }

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdState.rewardedAdUnit!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) => setState(() => _rewardedAd = ad),
        onAdFailedToLoad: (LoadAdError error) =>
            setState(() => _rewardedAd = null),
      ),
    );
  }

  void showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          _rewardedAd!.dispose();
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _rewardedAd!.dispose();
          loadRewardedAd();
        },
      );

      if (Platform.isAndroid) {
        _rewardedAd!.setImmersiveMode(true);
      }
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) async {
          // awarding coins
          final response = await http.post(
            Uri.parse(
              'https://bet-app-e520a.ew.r.appspot.com/v1/users/$uid/coins',
            ),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );

          // displaying a snackbar
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: nunitoText('100 coins were awarded', 16, FontWeight.bold,
                  Colors.black)));
        },
      );

      _rewardedAd = null;
      loadRewardedAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usableWidth = MediaQuery.of(context).size.width * 0.9;
    final cardWidth = usableWidth * 0.4;
    final cardHeight = MediaQuery.of(context).size.height * 0.25;

    const itemCount = 4;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: nunitoText('Shop', 26, FontWeight.bold, Colors.black),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
                        FontWeight.normal, Colors.grey),
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
                                    textAlign: TextAlign.center),
                              ),
                              IconButton(
                                onPressed: () => showRewardedAd(),
                                highlightColor:
                                    const Color.fromARGB(255, 255, 187, 85),
                                color: const Color.fromARGB(255, 96, 179, 255),
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

              // SECOND SECTION - BACKGROUNDS

              SizedBox(
                width: usableWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    nunitoText("Profile backgrounds", 18, FontWeight.bold,
                        Colors.black),
                    nunitoText(
                        "Stick your favourite pattern on your profile for others to see",
                        14,
                        FontWeight.normal,
                        Colors.grey),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: cardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: itemCount,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                          index == 0 ? usableWidth / 18 : 8,
                          8,
                          index == itemCount - 1 ? usableWidth / 18 : 8,
                          8),
                      child: Card(
                        elevation: 5,
                        surfaceTintColor: Colors.white,
                        child: SizedBox(
                          width: cardWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              nunitoText(index.toString(), 16,
                                  FontWeight.normal, Colors.black),
                              SvgPicture.asset(
                                'lib/assets/images/futbol-regular.svg',
                                width: cardWidth * 0.5,
                                height: cardHeight * .5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // THIRD SECTION - JERSEYS

              SizedBox(
                width: usableWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    nunitoText("Jerseys", 18, FontWeight.bold, Colors.black),
                    nunitoText("Get a beautiful jersey to present your name",
                        14, FontWeight.normal, Colors.grey),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: cardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: itemCount,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                          index == 0 ? usableWidth / 18 : 8,
                          8,
                          index == itemCount - 1 ? usableWidth / 18 : 8,
                          8),
                      child: Card(
                        elevation: 5,
                        surfaceTintColor: Colors.white,
                        child: SizedBox(
                          width: cardWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              nunitoText(index.toString(), 16,
                                  FontWeight.normal, Colors.black),
                              SvgPicture.asset(
                                'lib/assets/images/futbol-regular.svg',
                                width: cardWidth * 0.5,
                                height: cardHeight * .5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // FOURTH SECTION - NUMBERS

              SizedBox(
                width: usableWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    nunitoText("Numbers", 18, FontWeight.bold, Colors.black),
                    nunitoText("Stick your favourite number on your jersey", 14,
                        FontWeight.normal, Colors.grey),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: cardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: itemCount,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                          index == 0 ? usableWidth / 18 : 8,
                          8,
                          index == itemCount - 1 ? usableWidth / 18 : 8,
                          8),
                      child: Card(
                        elevation: 5,
                        surfaceTintColor: Colors.white,
                        child: SizedBox(
                          width: cardWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              nunitoText(index.toString(), 16,
                                  FontWeight.normal, Colors.black),
                              SvgPicture.asset(
                                'lib/assets/images/futbol-regular.svg',
                                width: cardWidth * 0.5,
                                height: cardHeight * .5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // FIFTH SECTION - PROFILE BORDERS

              SizedBox(
                width: usableWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    nunitoText(
                        "Profile borders", 18, FontWeight.bold, Colors.black),
                    nunitoText("Enhance your profile with a stylish border", 14,
                        FontWeight.normal, Colors.grey),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: cardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: itemCount,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                          index == 0 ? usableWidth / 18 : 8,
                          8,
                          index == itemCount - 1 ? usableWidth / 18 : 8,
                          8),
                      child: Card(
                        elevation: 5,
                        surfaceTintColor: Colors.white,
                        child: SizedBox(
                          width: cardWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              nunitoText(index.toString(), 16,
                                  FontWeight.normal, Colors.black),
                              SvgPicture.asset(
                                'lib/assets/images/futbol-regular.svg',
                                width: cardWidth * 0.5,
                                height: cardHeight * .5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
