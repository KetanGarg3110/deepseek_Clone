import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-4258707331399502/4792655460';
      ///test ads
      return 'ca-app-pub-3940256099942544/9214589741';
    } else if (Platform.isIOS) {
      return '<Your_Ios_Banner_Ad_Id>';
    } else {
      throw UnimplementedError('UnSupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      //  return 'ca-app-pub-4258707331399502/2327333719';
      ///test ads
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return '<Your_Ios_Banner_Ad_Id>';
    } else {
      throw UnimplementedError('UnSupported platform');
    }
  }
}
