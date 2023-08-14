import 'package:flutter/material.dart';
import 'package:technomaths/themes/theme_data.dart';  // Import the theme data file
import 'package:technomaths/models/custom_theme_Data.dart';  // Import the CustomThemeData model

class ThemeNotifier extends ChangeNotifier {
  CustomThemeData _currentTheme;

  ThemeNotifier(this._currentTheme);

  ThemeData getTheme() => _currentTheme.themeData;  // Return the ThemeData inside CustomThemeData

  CustomThemeData getCurrentTheme() => _currentTheme;  // If you ever want to get the whole CustomThemeData

  setTheme(CustomThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  // If needed, you can add additional methods to get the positiveColor or other properties from CustomThemeData
  Color getPositiveColor() => _currentTheme.positiveColor;
}
