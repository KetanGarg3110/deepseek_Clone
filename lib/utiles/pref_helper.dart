import 'package:hive_flutter/hive_flutter.dart';

class Pref {
  static late Box _box;

  static Future<void> initialize() async {
    // To initialize  hive to use the app directory
    // final dir =await getApplicationDocumentsDirectory();
    await Hive.initFlutter();
    _box = await Hive.openBox('app_prefs');
  }

  // make PrefHelper has a getter and setter for onboarding status.
  static bool get showOnBoarding =>
      _box.get('show_onboarding', defaultValue: true);
  static set showOnBoarding(bool v) => _box.put('show_onboarding', v);

  // normal way -Get
  //showOnBoarding()

  // static bool showOnBoarding() {
  //   return _box.get('showOnBoarding ', defaultValue: true);
  // }

  //Normal Way -Set
  //showOnBoarding(false);

  // static bool showOnBoarding(bool v) {
  //   _box.put('showOnBoarding', v);
  // }
}
