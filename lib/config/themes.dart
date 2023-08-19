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
  textColor: Colors.blueAccent,
  btnTextColor: Colors.white,
  headerColor: Colors.blueAccent,
  iconColor: Colors.blueAccent,
  btnTextColorReverse: Colors.black,
  errorColor: Colors.red,
  positiveColor: Colors.green,
  progressBarBackground: Colors.grey[300]!,
  positiveColorLight: Colors.green[400]!,
  positiveColorDark: Colors.green[700]!,
  backdropBackgroundColor: Colors.black,
  bestScoreBackground: Colors.amber[100]!,
  buttonIndicatorColor: Colors.yellowAccent,
  tableSurroundColor: Colors.white,
);

final CustomTheme darkTheme = CustomTheme(
  themeData: ThemeData(
    primaryColor: Colors.teal[800]!,  // A muted teal color for primary
    colorScheme: ColorScheme.dark(
      primary: Colors.teal[600]!,
      secondary: Colors.deepPurple,  // A muted purple for secondary
    ),
    brightness: Brightness.dark,
    // add other theme data you need
  ),
  textColor: Colors.tealAccent[200]!,
  btnTextColor: Colors.white,  // A lighter teal color for button text
  headerColor: Colors.tealAccent[200]!,
  iconColor: Colors.tealAccent[200]!,
  btnTextColorReverse: Colors.black,      // Kept the same
  errorColor: Colors.red,                 // Universal indicator
  positiveColor: Colors.green,            // Universal indicator
  progressBarBackground: Colors.grey[200]!,  // Darker shade for dark mode
  positiveColorLight: Colors.green[400]!,   // Kept the same
  positiveColorDark: Colors.green[700]!,    // Kept the same
  backdropBackgroundColor: Colors.grey[850]!,  // A very dark grey for backdrop
  bestScoreBackground: Colors.deepPurple[600]!,    // A dark shade of amber
  buttonIndicatorColor: Colors.amberAccent,   // Amber accent for indicator
  tableSurroundColor: Colors.grey[800]!,
);





final Map<String, CustomTheme> themes = {
  'light': lightTheme,
  'dark': darkTheme,
};
