// services/preferences_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import '../themes/theme_data.dart';

class PreferencesService {
  static Future<void> setTheme(CustomTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme.toString());
  }

  static Future<CustomTheme> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('theme') ?? CustomTheme.Blue.toString();
    return CustomTheme.values.firstWhere((e) => e.toString() == themeString, orElse: () => CustomTheme.Blue);
  }
}
