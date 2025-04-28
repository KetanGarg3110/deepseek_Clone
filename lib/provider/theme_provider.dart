import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{

  bool _isDarkMode =false;

  ThemeProvider(){
    _loadTheme();
}

bool getThemeValue() => _isDarkMode;

  Future<void> _loadTheme() async{
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode =prefs.getBool("isDarkMode")??false;
    notifyListeners();
  }

  void toggleTheme(){
    _isDarkMode =!_isDarkMode;
    _saveTheme();
    notifyListeners();
  }

  void _saveTheme() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", _isDarkMode);
  }
}