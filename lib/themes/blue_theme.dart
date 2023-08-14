// blue_theme.dart

import 'package:flutter/material.dart';

import '../models/custom_theme_Data.dart';


final CustomThemeData blueTheme = CustomThemeData(
  themeData: ThemeData(
    primaryColor: Colors.blueAccent,
    backgroundColor: Colors.blue[50],
    colorScheme: ColorScheme.light(
      primary: Colors.blueAccent,
      secondary: Colors.deepPurple,
      onPrimary: Colors.white,
      surface: Colors.blueGrey[50]!,
    ),
  ),
  positiveColor: Colors.green,
);

final LinearGradient blueButtonGradient = LinearGradient(
  colors: [Colors.deepPurple, Colors.blueAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
