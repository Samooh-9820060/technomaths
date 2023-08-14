import 'package:flutter/material.dart';
import 'package:technomaths/models/custom_theme_Data.dart';
import '../themes/theme_data.dart';
import '../utils/preferences_service.dart';

class ThemeManager with ChangeNotifier {
  late CustomThemeData _themeData;

  ThemeManager() {
    _loadTheme();
  }

  ThemeData get theme => _themeData.themeData;

  void _loadTheme() async {
    CustomTheme theme = await PreferencesService.getTheme();
    _themeData = AppThemes.themes[theme]!;
    notifyListeners();
  }

  void setTheme(CustomTheme theme) async {
    _themeData = AppThemes.themes[theme]!;
    await PreferencesService.setTheme(theme);
    notifyListeners();
  }
}