import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:technomaths/screens/home_screen.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await AndroidAlarmManager.initialize();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  commonFunctions.setDefaultPreferences();
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(const MyApp());
  //debugPaintSizeEnabled = true;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechnoMaths',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,

    );
  }
}