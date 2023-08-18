import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/config/game_mode.dart';
import 'package:technomaths/screens/settings.dart';
import 'package:technomaths/screens/wall_of_fame.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import 'package:technomaths/utils/devUseMethods.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:flutter/services.dart';
import 'package:technomaths/screens/endless_mode_screen.dart';

import '../utils/notification_service.dart';

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
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'TechnoMaths',
                style: GoogleFonts.fredoka(fontSize: 40, color: Colors.blueAccent),
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
              AnimatedButton('Test Button', onPressed: () async {
                //await devUseMethods.addMessagesInBulk();
                final notificationService = NotificationService();
                await notificationService.initialize();

              }),
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
