import "dart:io";

import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: avoid_classes_with_only_static_members
class Globals {

  static RewardedAd? rewardedAd;

  static void loadRewardedAd(){
    RewardedAd.load(
      adUnitId: rewardedAdUnit!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) => rewardedAd = ad,
        onAdFailedToLoad: (LoadAdError error) => rewardedAd = null,
      ),
    );
  }

  static String? get rewardedAdUnit{
    if (Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    }
  return null;
  }

  static String? get bannerAdUnit{
    if (Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return null;
  }

  static String? get interstitialAdUnit{
    if (Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    return null;
  }
}
