import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../config/ad_config.dart';
import '../config/app_config.dart';

class commonFunctions {
  static Future<String> getDeviceUUID() async {
    final prefs = await SharedPreferences.getInstance();
    String? uuid = prefs.getString('device_uuid');

    if (uuid == null) {
      uuid = Uuid().v4();  // Generate a new UUID
      await prefs.setString('device_uuid', uuid);
    }

    return uuid;
  }

  static Future<String?> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      return null;
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          return '${androidInfo.brand}-${androidInfo.model}-${androidInfo.product}-${androidInfo.fingerprint}';
        case TargetPlatform.iOS:
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          return iosInfo.identifierForVendor;
      // Add more platforms if needed.
        default:
          return null;
      }
    }
  }

  static int convertTimeStringToSeconds(String time) {
    List<String> parts = time.split(':');
    if (parts.length != 2) return 0;

    int minutes = int.tryParse(parts[0]) ?? 0;
    int seconds = int.tryParse(parts[1]) ?? 0;

    return minutes * 60 + seconds;
  }
  static String convertSecondsToTimeString(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  static Future<bool> checkVibrationSupport() async {
    //check if vibration is enabled from settings
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isVibrationOn') ?? true) {
      return true;
    } else {
      return false;
    }
  }

  static String getAdUnitId(AdType adType) {
    AppPlatform currentPlatform;
    if (Platform.isAndroid) {
      currentPlatform = isTestingMode ? AppPlatform.testAndroid : AppPlatform.android;
    } else {
      currentPlatform = isTestingMode ? AppPlatform.testIos : AppPlatform.ios;
    }
    return adUnitIds[adType]?[currentPlatform] ?? 'default_ad_unit_id';
  }

  static String processDynamicParts(String text, int scoreInt, int rankInt) {
    // Pattern for {variable+number} or {variable-number}
    final regex = RegExp(r'\{(\w+)([+-]\d+)\}');

    return text.replaceAllMapped(regex, (match) {
      String variable = match.group(1)!;
      String operation = match.group(2)!;

      int baseValue;
      if (variable == "rank") {
        baseValue = rankInt;
      } else if (variable == "score") {
        baseValue = scoreInt;
      } else {
        // Unknown variable; return the original string
        return match.group(0)!;
      }

      int offset = int.parse(operation); // this will be positive for "+n" and negative for "-n"
      return (baseValue + offset).toString();
    });
  }



  //get set shared preferences
  static Future<bool> isNotificationAllowed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isNotificationsOn') ?? true;  // default to true if not set
  }
  static updatePreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
  static Future<void> setDefaultPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstRun = prefs.getBool('isFirstRun');

    // Check if notifications are permitted
    var permissionStatus = await NotificationPermissions.getNotificationPermissionStatus();
    bool areNotificationsPermitted = (permissionStatus == PermissionStatus.granted);

    if (!areNotificationsPermitted) {
      await prefs.setBool('isNotificationsOn', areNotificationsPermitted);
    }

    if (isFirstRun == null || isFirstRun) {
      await prefs.setBool('isVibrationOn', true);
      await prefs.setBool('isNotificationsOn', areNotificationsPermitted);
      // await prefs.setBool('isDarkTheme', true); // Uncomment this if you need it
      await prefs.setBool('isFirstRun', false);
    }
  }


}
