import 'dart:convert';
import 'dart:core';
import "dart:io";

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class Globals {

  static RewardedAd? rewardedAd;
  static SharedPreferences? sharedPreferences;
  static bool joinedNewLeague = false;
  static final Map<String, DateTime> _callTimes = {};
  static final Map<String, String> _callResponses = {};

  static const String callsSP = "calls";

  static Future<String> performCall(String uri) async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    if (_callTimes.isEmpty) {
      loadData();
    }

    if (shouldCall(uri))
    {
      print("will call");
      final http.Response response = await http.get(Uri.parse(uri));
      _callTimes[uri] = DateTime.now();
      _callResponses[uri] = response.body;
      saveData();
      return response.body;
    }
    else{
      print("wont call");
      return _callResponses[uri]!;
    }
  }

  static Future<void> loadData() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    final json = sharedPreferences!.getString(callsSP);

    if (json != null){
      final Map<String, dynamic> data = jsonDecode(json) as Map<String, dynamic>;

      data.entries.forEach((element) {
        final key = element.key;
        final time = element.value["time"] as String;
        final response = element.value["response"] as String;

        _callTimes[key] = DateTime.parse(time);
        _callResponses[key] = response;
      });
    }
  }

  static Future<bool> saveData() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    final Map<String, dynamic> data = {};
    // ignore: avoid_function_literals_in_foreach_calls
    _callTimes.keys.forEach((element) {
        final callTime = _callTimes[element].toString();
        final callResponse = _callResponses[element];

        data[element] = {
          "time": callTime,
          "response": callResponse,
        };
     });

    return await sharedPreferences!.setString(callsSP, jsonEncode(data));
  }

  static bool shouldCall(String uri){
    bool isUriMatching(String uri, RegExp regex) {
      return regex.hasMatch(uri);
    }

    final RegExp usersInLeague = RegExp(r'https:\/\/flask-vhn3gxevdq-ew\.a\.run\.app\/v1\/leagues\/.+\/users');
    final RegExp eventsInCompetition = RegExp(r'https:\/\/flask-vhn3gxevdq-ew\.a\.run\.app\/v1\/competitions\/.');
    final RegExp leaguesOfUser = RegExp(r'https:\/\/flask-vhn3gxevdq-ew\.a\.run\.app\/v1\/users\/.+\/leagues');
    final RegExp betsOfUser = RegExp(r'https:\/\/flask-vhn3gxevdq-ew\.a\.run\.app\/v1\/bets\/.');

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
