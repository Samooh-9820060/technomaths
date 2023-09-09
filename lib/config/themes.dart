import 'package:flutter/material.dart';
import 'package:technomaths/config/extended_theme.dart';

BoxDecoration getBackgroundDecoration(bool applyOpacity) {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/background.jpg"),
      fit: BoxFit.cover,
      colorFilter: applyOpacity
          ? ColorFilter.mode(
        Colors.black.withOpacity(0.4),
        BlendMode.dstATop,
      )
          : null,
    ),
  );
}

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
  buttonIndicatorColor: Colors.amberAccent,
  tableSurroundColor: Colors.white,
  backgroundDecoration: (_) => BoxDecoration(color: Colors.white),
  appBarBackgroundColor: Colors.deepPurple,
  appBarBackgroundDecoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.deepPurple, Colors.blueAccent],
    ),
  ),
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
  buttonIndicatorColor: Colors.purple,  // A darker shade of amber for button indicator
  tableSurroundColor: Colors.grey[800]!, // Very dark grey for table surrounds
  backgroundDecoration: getBackgroundDecoration,
  appBarBackgroundColor: Colors.transparent,
  appBarBackgroundDecoration: BoxDecoration(
    color: Colors.transparent,
  ),
);






final Map<String, CustomTheme> themes = {
  'light': lightTheme,
  'dark': darkTheme,
};
