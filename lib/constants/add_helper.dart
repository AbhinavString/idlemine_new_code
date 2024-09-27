import 'dart:io';

class AdHelper {
  static String get interstiatalRewardAdId {
    if (Platform.isAndroid)
      return 'ca-app-pub-6466880914736130/5343619579';
    else
      return 'ca-app-pub-6466880914736130/6624347006';
  }

  static String get rewardAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6466880914736130/8484223583';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6466880914736130/8392740156';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get interstitalAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6466880914736130/5511140534';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6466880914736130/1296563352';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6466880914736130/4790151466';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6466880914736130/3834548045';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6466880914736130/4544978575';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6466880914736130/6780275589';
    }
    throw UnsupportedError("Unsupported platform");
  }
}