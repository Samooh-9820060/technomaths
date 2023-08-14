import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:technomaths/screens/home_screen.dart';
import 'package:provider/provider.dart'; // <-- Import the provider package
import 'package:technomaths/themes/red_theme.dart';
import 'package:technomaths/utils/theme_notifier.dart'; // <-- Import your ThemeNotifier

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(redTheme),  // <-- Use blueTheme as the default theme
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: 'TechnoMaths',
            theme: notifier.getTheme(),  // <-- Use the theme from ThemeNotifier
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}