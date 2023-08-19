import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:technomaths/screens/home_screen.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'config/theme_notifier.dart';
import 'config/themes.dart';
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

  String? initialThemeKey = await commonFunctions.getPreference('appTheme', '');
  runApp(MyApp(initialThemeKey: initialThemeKey ?? 'light'));
  //debugPaintSizeEnabled = true;
}

class MyApp extends StatelessWidget {
  final String initialThemeKey;

  const MyApp({Key? key, required this.initialThemeKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeNotifier(themes[initialThemeKey]!, initialThemeKey),
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, child) => MaterialApp(
          title: 'TechnoMaths',
          theme: theme.getTheme(),
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}