import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:technomaths/config/extended_theme.dart';
import 'package:technomaths/screens/settings.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:flutter/services.dart';
import 'package:technomaths/screens/endless_mode_screen.dart';
import 'package:technomaths/config/extended_theme.dart';

import '../config/theme_notifier.dart';
import '../config/themes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> performVibration() async {
    bool canVibrate = await commonFunctions.checkVibrationSupport();
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.medium); // You can adjust the feedback type as per your preference.
    }
  }

  @override
  Widget build(BuildContext context) {
    Color headingColor = themes[Provider.of<ThemeNotifier>(context).currentThemeKey]!.themeData.colorScheme.secondary;

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'TechnoMaths',
                style: GoogleFonts.fredoka(fontSize: 40, color: headingColor),
              ),
              SizedBox(height: 50), // Add this for extra space
              AnimatedButton('Endless', onPressed: () async {
                await performVibration();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EndlessModeScreen()),
                );
              }),
              //AnimatedButton('Levels', onPressed: () {
                // Code to go to the levels
              //}),
              /*AnimatedButton('Test Button', onPressed: () async {
                //await devUseMethods.addMessagesInBulk();
                final notificationService = NotificationService();
                await notificationService.initialize();
              }),*/
              AnimatedButton('Settings', onPressed: () async {
                await performVibration();
                // Settings code
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              }),
              AnimatedButton('Quit', onPressed: () async {
                await performVibration();
                SystemNavigator.pop();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
