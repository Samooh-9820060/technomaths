import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceUUIDUtil {
  static Future<String> getDeviceUUID() async {
    final prefs = await SharedPreferences.getInstance();
    String? uuid = prefs.getString('device_uuid');

    if (uuid == null) {
      uuid = Uuid().v4();  // Generate a new UUID
      await prefs.setString('device_uuid', uuid);
    }

    return uuid;
  }
}
