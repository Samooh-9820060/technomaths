import 'package:flutter/material.dart';
typedef BoxDecorationBuilder = BoxDecoration Function(bool applyOpacity);

class CustomTheme {
  final ThemeData themeData;
  final Color textColor;
  final Color btnTextColor;
  final Color btnTextColorReverse;
  final Color headerColor;
  final Color iconColor;
  final Color errorColor;
  final Color positiveColor;
  final Color positiveColorLight;
  final Color positiveColorDark;
  final Color progressBarBackground;
  final Color backdropBackgroundColor;
  final Color bestScoreBackground;
  final Color buttonIndicatorColor;
  final Color tableSurroundColor;
  final BoxDecorationBuilder backgroundDecoration;
  final Color appBarBackgroundColor;
  final BoxDecoration? appBarBackgroundDecoration;

  CustomTheme({
    required this.themeData,
    this.textColor = Colors.blueAccent,
    this.btnTextColor = Colors.black,
    this.btnTextColorReverse = Colors.white,
    this.headerColor = Colors.blueAccent,
    this.iconColor = Colors.blueAccent,
    this.errorColor = Colors.red,
    this.positiveColor = Colors.green,
    this.positiveColorLight = Colors.lightGreen,
    this.positiveColorDark = Colors.greenAccent,
    this.progressBarBackground = Colors.grey,
    this.backdropBackgroundColor = Colors.black,
    this.bestScoreBackground = Colors.amber,
    this.buttonIndicatorColor = Colors.yellowAccent,
    this.tableSurroundColor = Colors.white,
    required this.backgroundDecoration,
    required this.appBarBackgroundColor,
    this.appBarBackgroundDecoration,
  });
}
