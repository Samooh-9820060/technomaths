import 'package:flutter/material.dart';
import '../models/custom_theme_Data.dart';  // Assuming this is the correct path to your custom theme data model

final CustomThemeData redTheme = CustomThemeData(
  themeData: ThemeData(
    primaryColor: Colors.redAccent,
    backgroundColor: Colors.red[50],  // Added background color for red theme
    colorScheme: ColorScheme.light(
      primary: Colors.redAccent,
      secondary: Colors.deepOrange,
      onPrimary: Colors.white,
      surface: Colors.red[100]!,  // Adjusted surface color for the red theme
    ),
  ),
  positiveColor: Colors.green,  // Using green as positive color as it's a universal positive signal
);

final LinearGradient redButtonGradient = LinearGradient(
  colors: [Colors.deepOrange, Colors.redAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);