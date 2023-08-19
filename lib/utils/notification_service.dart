import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import 'firestore_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
          onSelectNotification(notificationResponse.payload);
        }
    );

    startRecurringTask();
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload == null) return;

    // Initialize Firestore
    await Firebase.initializeApp();

    final firestoreService = FirestoreService();

    // Fetch the document using the payload as ID and update the clickCount field
    await firestoreService.updateClickCount(payload);
  }

  Future<void> startRecurringTask() async {
    final int alarmId = 0;
    await AndroidAlarmManager.periodic(
        const Duration(hours: 8),
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
    Map<String, String> result = await FirestoreService.generateMessage(randomGameMode, score!, rank!);
    final String body = result["message"]!;
    final String documentId = result["documentId"]!;

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
      payload: documentId,
    );
  }
}