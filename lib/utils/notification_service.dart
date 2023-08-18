import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import 'firestore_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    startRecurringTask();
  }

  Future<void> startRecurringTask() async {
    final int alarmId = 0;
    await AndroidAlarmManager.periodic(
        const Duration(minutes: 1),
        alarmId,
        scheduleDynamicNotification,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> scheduleDynamicNotification() async {

    bool showNotification = await commonFunctions.isNotificationAllowed();
    if (!showNotification) {
      return; // Exit if notifications are turned off
    }

    await Firebase.initializeApp();

    // Fetch player's highest score
    final firestoreService = FirestoreService();
    final Map<String, Map<String, int>> highestScores = (await firestoreService.fetchPlayerHighestScores()).cast<String, Map<String, int>>();

    Random rand = Random();
    String randomGameMode = highestScores.keys.elementAt(rand.nextInt(highestScores.length)).toString();

    String? score = highestScores[randomGameMode]?['score'].toString();
    String? rank = highestScores[randomGameMode]?['rank'].toString();

    final String title = "TechnoMaths";
    final String body = await FirestoreService.generateMessage(randomGameMode, score!, rank!);

    // Notification details
    const int notificationId = 0;
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'technomaths_challenges_channel', 'TechnoMaths Challenges', channelDescription: 'Dive back into TechnoMaths! Fun challenges and surprises await.',
        importance: Importance.max,
        priority: Priority.high,
      styleInformation: BigTextStyleInformation(body)
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}