// themes/theme_data.dart

import 'package:flutter/material.dart';
import '../models/custom_theme_Data.dart';
import 'blue_theme.dart';
import 'green_theme.dart';
import 'red_theme.dart';

enum CustomTheme { Blue, Green, Red }

class AppThemes {
  static final Map<CustomTheme, CustomThemeData> themes = {
    CustomTheme.Blue: blueTheme,
    CustomTheme.Green: greenTheme,
    CustomTheme.Red: redTheme,
  };

  static final Map<CustomTheme, LinearGradient> buttonGradients = {
    CustomTheme.Blue: blueButtonGradient,
    CustomTheme.Green: greenButtonGradient, // you need to define these in respective files
    CustomTheme.Red: redButtonGradient,
  };

  // Add this to fetch background colors based on theme
  static Color getBackgroundColor(CustomTheme theme) {
    return themes[theme]?.themeData.backgroundColor ?? Colors.white;
  }
}
