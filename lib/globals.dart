import "dart:io";
import 'dart:core';

import 'package:http/http.dart' as http;

import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: avoid_classes_with_only_static_members
class Globals {

  static RewardedAd? rewardedAd;
  static bool joinedNewLeague = false;
  static final Map<String, DateTime> _callTimes = {};
  static final Map<String, dynamic> _callResponses = {};

  static Future<http.Response> performCall(String uri) async {
    if (_shouldCall(uri))
    {
      print("will call");
      final http.Response response = await http.get(Uri.parse(uri));
      _callTimes[uri] = DateTime.now();
      _callResponses[uri] = response;
      return response;
    }
    else{
      print("wont call");
      return _callResponses[uri] as http.Response;
    }
  }

  static bool _shouldCall(String uri){
    bool isUriMatching(String uri, RegExp regex) {
      return regex.hasMatch(uri);
    }

    final RegExp usersInLeague = RegExp(r'https:\/\/bet-app-e520a\.ew\.r\.appspot\.com\/v1\/leagues\/.+\/users');
    final RegExp eventsInCompetition = RegExp(r'https:\/\/bet-app-e520a\.ew\.r\.appspot\.com\/v1\/competitions\/.');
    final RegExp leaguesOfUser = RegExp(r'https:\/\/bet-app-e520a\.ew\.r\.appspot\.com\/v1\/users\/.+\/leagues');
    final RegExp betsOfUser = RegExp(r'https:\/\/bet-app-e520a\.ew\.r\.appspot\.com\/v1\/bets\/.');

    if (isUriMatching(uri, usersInLeague)){
      // if has never made this call -> should call
      if (!_callTimes.containsKey(uri))
      {
        return true;
      }

      final callTime = _callTimes[uri]!;

      // if has made this call more than day ago -> should call
      if (callTime.add(const Duration(days: 1)).isBefore(DateTime.now()))
      {
        return true;
      }
      // if has made this call yesterday -> should call
      return callTime.day < DateTime.now().day;
    } 
    
    else if (isUriMatching(uri, eventsInCompetition)){
      // if has never made this call -> should call
      if (!_callTimes.containsKey(uri))
      {
        return true;
      }

      final callTime = _callTimes[uri]!;

      // if has made this call today before an update -> should call
      final now = DateTime.now();
      const invocationTime = 15;
      DateTime lastUpdate = DateTime(now.year, now.month, now.day, invocationTime);

      if (lastUpdate.isAfter(now)){
        lastUpdate = DateTime(now.year, now.month, now.day, invocationTime - 12);
        if (lastUpdate.isAfter(now)){
          final yesterday = DateTime.now().subtract(const Duration(days: 1));
          lastUpdate = DateTime(now.year, now.month, yesterday.day, invocationTime);
        }
      }

      return callTime.isBefore(lastUpdate);
    } 
    
    else if (isUriMatching(uri, leaguesOfUser)){
      if (joinedNewLeague){
        joinedNewLeague = false;
        return true;
      }

      // if has never made this call -> should call
      if (!_callTimes.containsKey(uri))
      {
        return true;
      }

      // if has made this call yesterday -> should call
      return _callTimes[uri]!.day < DateTime.now().day;
    } 
    
    else if (isUriMatching(uri, betsOfUser)){
      // if has never made this call -> should call
      if (!_callTimes.containsKey(uri))
      {
        return true;
      }

      final callTime = _callTimes[uri]!;

      // if has made this call more than day ago -> should call
      if (callTime.add(const Duration(days: 1)).isBefore(DateTime.now()))
      {
        return true;
      }
      // if has made this call yesterday -> should call
      return callTime.day < DateTime.now().day;
    }

    return true;
  }

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
