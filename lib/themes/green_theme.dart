import 'package:flutter/material.dart';
import '../models/custom_theme_Data.dart';  // Assuming this is the correct path to your custom theme data model

final CustomThemeData greenTheme = CustomThemeData(
  themeData: ThemeData(
    primaryColor: Colors.greenAccent,
    backgroundColor: Colors.green[50],  // Adjusted background color for green theme
    colorScheme: ColorScheme.light(
      primary: Colors.greenAccent,
      secondary: Colors.teal,
      onPrimary: Colors.white,
      surface: Colors.green[50]!,  // Adjusted surface color; note: there's no `greenGrey` color in Flutter by default. You might need to adjust this.
    ),
  ),
  positiveColor: Colors.green,
);

final LinearGradient greenButtonGradient = LinearGradient(
  colors: [Colors.teal, Colors.greenAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
