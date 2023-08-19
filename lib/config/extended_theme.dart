import 'package:flutter/material.dart';

class CustomTheme {
  final ThemeData themeData;
  final Color btnTextColor;
  final Color btnTextColorReverse;
  final Color errorColor;
  final Color positiveColor;
  final Color positiveColorLight;
  final Color positiveColorDark;
  final Color progressBarBackground;
  final Color backdropBackgroundColor;

  CustomTheme({
    required this.themeData,
    this.btnTextColor = Colors.black,
    this.btnTextColorReverse = Colors.white,
    this.errorColor = Colors.red,
    this.positiveColor = Colors.green,
    this.positiveColorLight = Colors.lightGreen,
    this.positiveColorDark = Colors.greenAccent,
    this.progressBarBackground = Colors.grey,
    this.backdropBackgroundColor = Colors.black,
  });
}
