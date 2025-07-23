import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.light;

  ThemeMode get currentTheme => _currentTheme;

  ThemeNotifier() {
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    _currentTheme = _currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemeToPrefs();
    notifyListeners();
  }

  void _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _currentTheme = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _currentTheme == ThemeMode.dark);
  }
}

final themeNotifier = ThemeNotifier();
