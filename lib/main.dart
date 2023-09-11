import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:technomaths/screens/home_screen.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'config/extended_theme.dart';
import 'config/theme_notifier.dart';
import 'config/themes.dart';
import 'utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await AndroidAlarmManager.initialize();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  final notificationService = NotificationService();
  await notificationService.initialize();

  String? initialThemeKey = await commonFunctions.getPreference('appTheme', '');

  if (initialThemeKey == null || !themes.containsKey(initialThemeKey)) {
    initialThemeKey = 'light';  // Provide a default theme key if null or not in themes map
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        CustomTheme? initialTheme = themes[initialThemeKey];
        return ThemeNotifier(initialTheme ?? themes['light']!, initialThemeKey ?? 'light');
      },
      child: MyApp(initialThemeKey: initialThemeKey ?? 'light'),
    ),
  );

}



class MyApp extends StatefulWidget {
  final String initialThemeKey;

  const MyApp({Key? key, required this.initialThemeKey}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData _currentTheme;

  @override
  void initState() {
    super.initState();

    CustomTheme? initialTheme = themes[widget.initialThemeKey];
    _currentTheme = initialTheme?.themeData ?? themes['light']!.themeData;

    // Call your function here
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await commonFunctions.setDefaultPreferences(context);

      // After preferences are set, read the initial theme again
      String? updatedThemeKey = await commonFunctions.getPreference('appTheme', '');

      // Update theme if it's different
      if (updatedThemeKey != widget.initialThemeKey) {
        setState(() {
          _currentTheme = themes[updatedThemeKey!]!.themeData;
        });
      }
      Provider.of<ThemeNotifier>(context, listen: false).setTheme(updatedThemeKey!);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechnoMaths',
      theme: _currentTheme,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}