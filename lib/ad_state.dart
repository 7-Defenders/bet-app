import "dart:io";

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {

  static String? get rewardedAdUnit{
  if (Platform.isAndroid){
    return 'ca-app-pub-3940256099942544/5224354917';
  } else if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/1712485313';
  }
  return null;
  }
}
