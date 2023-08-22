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
  textColor: Colors.blue[800]!,
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
    primaryColor: Colors.black,  // Pure black for primary color
    colorScheme: ColorScheme.dark(
      primary: Colors.teal[700]!,  // A deeper teal for primary in dark mode
      secondary: Colors.purple[700]!,  // A deeper purple for secondary
      background: Colors.black,  // Dark background
      surface: Colors.grey[900]!, // Slightly lighter surface color
    ),
    brightness: Brightness.dark,
    //canvasColor: Colors.black,
    // add other theme data you need
  ),
  textColor: Colors.tealAccent[400]!,  // Brighter teal accent for text
  btnTextColor: Colors.white,
  headerColor: Colors.tealAccent[400]!,
  iconColor: Colors.tealAccent[400]!,
  btnTextColorReverse: Colors.grey[300]!,  // Lighter color for reversed button text
  errorColor: Colors.red[700]!,  // Deeper red for error
  positiveColor: Colors.green[700]!,  // Deeper green for positive feedback
  progressBarBackground: Colors.grey[700]!,  // Darker shade for progress bar
  positiveColorLight: Colors.green[600]!,
  positiveColorDark: Colors.green[800]!,
  backdropBackgroundColor: Colors.black,  // Pure black backdrop
  bestScoreBackground: Colors.purple[800]!,  // Deep shade for the best score background
  buttonIndicatorColor: Colors.amber[700]!,  // A darker shade of amber for button indicator
  tableSurroundColor: Colors.grey[850]!, // Very dark grey for table surrounds
);






final Map<String, CustomTheme> themes = {
  'light': lightTheme,
  'dark': darkTheme,
};
