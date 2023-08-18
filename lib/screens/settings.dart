import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technomaths/utils/commonFunctions.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isVibrationOn = true;
  bool _isNotificationsOn = true;

  //bool _isDarkTheme = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialPreferences();
  }

  _loadInitialPreferences() async {
    var preferences = await _loadPreferences();
    setState(() {
      _isVibrationOn = preferences['isVibrationOn']!;
      _isNotificationsOn = preferences['isNotificationsOn']!;
      _isLoading = false;
    });
  }

  Future<Map<String, bool>> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'isVibrationOn': prefs.getBool('isVibrationOn') ?? true,
      'isNotificationsOn': prefs.getBool('isNotificationsOn') ?? true,
      //'isDarkTheme': prefs.getBool('isDarkTheme') ?? true,
    };
  }

  _toggleTheme(bool isDark) {
    setState(() {
      //_isDarkTheme = isDark;
      commonFunctions.updatePreference('isDarkTheme', isDark);
      // TODO: You can also update your app's theme here
    });
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
              Text('Choose Theme',
                  style: GoogleFonts.fredoka(
                      color: Colors.blue[900], fontSize: 22)),
              ListTile(
                title: Text('Light Theme',
                    style: GoogleFonts.fredoka(color: Colors.blue[900])),
                onTap: () {
                  _toggleTheme(false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Dark Theme',
                    style: GoogleFonts.fredoka(color: Colors.blue[900])),
                onTap: () {
                  _toggleTheme(true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.fredoka(fontSize: 22)),
        // Use a different font
        backgroundColor: Colors.deepPurple,
        // Gradient start color
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple, Colors.blueAccent],
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            ListTile(
              title: Text(
                'Vibration',
                style: GoogleFonts.fredoka(color: Colors.purple),
              ),
              trailing: Switch(
                value: _isVibrationOn,
                onChanged: (bool value) {
                  setState(() {
                    _isVibrationOn = value;
                    commonFunctions.updatePreference('isVibrationOn', value);
                  });
                },
                activeColor: Colors.blueAccent,
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Notifications',
                style: GoogleFonts.fredoka(color: Colors.purple),
              ),
              trailing: Switch(
                value: _isNotificationsOn,
                onChanged: (bool value) {
                  setState(() {
                    _isNotificationsOn = value;
                    commonFunctions.updatePreference('isNotificationsOn', value);
                  });
                },
                activeColor: Colors.blueAccent,
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Change Theme',
                style: GoogleFonts.fredoka(color: Colors.purple),
              ),
              trailing: Icon(Icons.color_lens, color: Colors.blueAccent),
              onTap: () {
                _showThemeBottomSheet(context);
              },
            ),
            Divider(),
            ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
