import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
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
}
