import 'package:flutter/material.dart';
import 'package:technomaths/config/extended_theme.dart';

final CustomTheme lightTheme = CustomTheme(
  themeData: ThemeData(
    primaryColor: Colors.deepPurple,
    colorScheme: ColorScheme.light(
      primary: Colors.deepPurple,
      secondary: Colors.blueAccent,
    ),
    brightness: Brightness.light,
    // add other theme data you need
  ),
  btnTextColor: Colors.white,
  btnTextColorReverse: Colors.black,
  errorColor: Colors.red,
  positiveColor: Colors.green,
  progressBarBackground: Colors.grey[300]!,
  positiveColorLight: Colors.green[400]!,
  positiveColorDark: Colors.green[700]!,
  backdropBackgroundColor: Colors.black,

);

final CustomTheme darkTheme = CustomTheme(
  themeData: ThemeData(
    primaryColor: Colors.indigo[700],  // A dark shade for primary color
    colorScheme: ColorScheme.dark(
      primary: Colors.indigo[700]!,
      secondary: Colors.cyanAccent[100]!,  // A lighter shade for secondary color in dark mode
    ),
    brightness: Brightness.dark,
    // add other theme data you need
  ),
  btnTextColor: Colors.cyanAccent[200]!,
  btnTextColorReverse: Colors.black,
  errorColor: Colors.red,
  positiveColor: Colors.green,
  progressBarBackground: Colors.grey[300]!,
  positiveColorLight: Colors.green[400]!,
  positiveColorDark: Colors.green[700]!,
  backdropBackgroundColor: Colors.black,
);



final Map<String, CustomTheme> themes = {
  'light': lightTheme,
  'dark': darkTheme,
};
