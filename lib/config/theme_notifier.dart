import 'package:flutter/material.dart';
import 'package:technomaths/config/extended_theme.dart';
import 'package:technomaths/config/themes.dart';

class ThemeNotifier with ChangeNotifier {
  CustomTheme _currentTheme;
  String _currentThemeKey;

  ThemeNotifier(this._currentTheme, this._currentThemeKey);

  ThemeData getTheme() => _currentTheme.themeData;

  void setTheme(String themeKey) {
    _currentTheme = themes[themeKey]!;
    _currentThemeKey = themeKey;
    notifyListeners();
  }

  String get currentThemeKey => _currentThemeKey;
}

