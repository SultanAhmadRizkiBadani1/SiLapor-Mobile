import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    loadTheme();
  }

  void setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("theme_mode", mode.index);
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt("theme_mode");

    if (index != null) {
      _themeMode = ThemeMode.values[index];
      notifyListeners();
    }
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt("theme_mode");

    if (index != null) {
      _themeMode = ThemeMode.values[index];
    }
  }
}
