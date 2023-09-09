import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import '../config/ThemeHelper.dart';
import '../config/theme_notifier.dart';
import '../config/themes.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isVibrationOn = true;
  bool _isNotificationsOn = true;
  bool _isPersonalizedAdsOn = true;
  String _appTheme = 'light';
  bool _isLoading = true;
  String? appVersion;
  late var themeColors;

  @override
  void initState() {
    super.initState();
    _loadInitialPreferences();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = "Version ${packageInfo.version}";
    });
  }

  _loadInitialPreferences() async {
    var preferences = await _loadPreferences();
    setState(() {
      _isVibrationOn = preferences['isVibrationOn']!;
      _isNotificationsOn = preferences['isNotificationsOn']!;
      _isPersonalizedAdsOn = preferences['isPersonalizedAdsOn']!;
      _appTheme = preferences['appTheme']!;
      _isLoading = false;
    });
  }

  Future<Map<String, dynamic>> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'isVibrationOn': prefs.getBool('isVibrationOn') ?? true,
      'isNotificationsOn': prefs.getBool('isNotificationsOn') ?? true,
      'appTheme': prefs.getString('appTheme') ?? 'light',
      // Using new preference key
      'isPersonalizedAdsOn': prefs.getBool('isPersonalizedAdsOn') ?? true,
    };
  }

  _setAppTheme(String theme) {
    setState(() {
      _appTheme = theme;
      commonFunctions.updatePreference(
          'appTheme', theme); // Using new preference key
      // TODO: You can also update your app's theme here
    });

    Provider.of<ThemeNotifier>(context, listen: false).setTheme(theme);
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Theme',
                style: GoogleFonts.fredoka(
                    color: themeColors.textColor, fontSize: 22),
              ),
              ...themes.keys.map((themeKey) {
                return ListTile(
                  trailing: _appTheme == themeKey
                      ? Icon(Icons.check, color: themeColors.textColor)
                      : null,
                  title: Text(
                    themeKey[0].toUpperCase() +
                        themeKey.substring(1) +
                        ' Theme',
                    style: GoogleFonts.fredoka(color: themeColors.textColor),
                  ),
                  onTap: () {
                    _setAppTheme(themeKey);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    themeColors = ThemeHelper(context, listen: false);

    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Stack(children: [
      Container(
        decoration: themeColors.currentTheme.backgroundDecoration(true),
      ),
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: themeColors.iconColor),  // Your desired color
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Settings',
              style: GoogleFonts.fredoka(
                fontSize: 22,
                color: themeColors.textColor,
              )
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Vibration',
                        style:
                            GoogleFonts.fredoka(color: themeColors.textColor),
                      ),
                      subtitle: Text(
                        'Turn on or off vibrations for button clicks.',
                        style: TextStyle(
                            fontSize: 12,
                            color: themeColors.textColor.withOpacity(0.7)),
                      ),
                      trailing: Switch(
                        value: _isVibrationOn,
                        onChanged: (bool value) {
                          setState(() {
                            _isVibrationOn = value;
                            commonFunctions.updatePreference(
                                'isVibrationOn', value);
                          });
                        },
                        activeColor: themeColors.iconColor,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Notifications',
                        style:
                            GoogleFonts.fredoka(color: themeColors.textColor),
                      ),
                      subtitle: Text(
                        'Enable or disable app notifications.',
                        style: TextStyle(
                            fontSize: 12,
                            color: themeColors.textColor.withOpacity(0.7)),
                      ),
                      trailing: Switch(
                        value: _isNotificationsOn,
                        onChanged: (bool value) async {
                          if (!value) {
                            // If user is trying to switch off, just update the preference.
                            setState(() {
                              _isNotificationsOn = value;
                            });
                            commonFunctions.updatePreference(
                                'isNotificationsOn', value);
                          } else {
                            // If user is trying to switch on, check if permissions are granted.
                            var permissionStatus =
                                await NotificationPermissions
                                    .getNotificationPermissionStatus();
                            if (permissionStatus !=
                                PermissionStatus.granted) {
                              PackageInfo packageInfo =
                                  await PackageInfo.fromPlatform();
                              String packageName = packageInfo.packageName;

                              // If permissions are not granted, open app settings.
                              final intent = AndroidIntent(
                                action:
                                    'android.settings.APPLICATION_DETAILS_SETTINGS',
                                data: 'package:$packageName',
                                package: 'com.android.settings',
                              );
                              await intent.launch();
                            } else {
                              setState(() {
                                _isNotificationsOn = value;
                              });
                              commonFunctions.updatePreference(
                                  'isNotificationsOn', value);
                            }
                          }
                        },
                        activeColor: themeColors.iconColor,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Personalized Ads',
                        style:
                            GoogleFonts.fredoka(color: themeColors.textColor),
                      ),
                      subtitle: Text(
                        'Show ads based on your interests. Turn off for generic ads.',
                        style: TextStyle(
                            fontSize: 12,
                            color: themeColors.textColor.withOpacity(0.7)),
                      ),
                      trailing: Switch(
                        value: _isPersonalizedAdsOn,
                        onChanged: (bool value) {
                          setState(() {
                            _isPersonalizedAdsOn = value;
                            commonFunctions.updatePreference(
                                'isPersonalizedAdsOn', value);
                          });
                        },
                        activeColor: themeColors.iconColor,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Change Theme',
                        style:
                            GoogleFonts.fredoka(color: themeColors.textColor),
                      ),
                      subtitle: Text(
                        'Choose a theme that suits your style.',
                        style: TextStyle(
                            fontSize: 12,
                            color: themeColors.textColor.withOpacity(0.7)),
                      ),
                      trailing: Icon(Icons.color_lens,
                          color: themeColors.iconColor),
                      onTap: () {
                        _showThemeBottomSheet(context);
                      },
                    ),
                    Divider(),
                    /*ElevatedButton(
                onPressed: () {
                  //TODO: Add functionality for resetting data
                },
                child: Text('Reset Data',
                    style: GoogleFonts.fredoka(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[700],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
                ),
              ),*/
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  appVersion ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: themeColors.textColor.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
