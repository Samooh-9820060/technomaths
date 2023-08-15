import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isVibrationOn = true;
  bool _isNotificationsOn = true;
  //bool _isDarkTheme = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVibrationOn = prefs.getBool('isVibrationOn') ?? true;
      _isNotificationsOn = prefs.getBool('isNotificationsOn') ?? true;
      //_isDarkTheme = prefs.getBool('isDarkTheme') ?? true;
    });
  }

  _updatePreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  _toggleTheme(bool isDark) {
    setState(() {
      //_isDarkTheme = isDark;
      _updatePreference('isDarkTheme', isDark);
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
              Text('Choose Theme', style: GoogleFonts.fredoka(color: Colors.blue[900], fontSize: 22)),
              ListTile(
                title: Text('Light Theme', style: GoogleFonts.fredoka(color: Colors.blue[900])),
                onTap: () {
                  _toggleTheme(false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Dark Theme', style: GoogleFonts.fredoka(color: Colors.blue[900])),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.fredoka(fontSize: 22)), // Use a different font
        backgroundColor: Colors.deepPurple, // Gradient start color
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
                style: GoogleFonts.fredoka(color: Colors.blue[900]),
              ),
              trailing: Switch(
                value: _isVibrationOn,
                onChanged: (bool value) {
                  setState(() {
                    _isVibrationOn = value;
                    _updatePreference('isVibrationOn', value);
                  });
                },
                activeColor: Colors.blue[900],
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Notifications',
                style: GoogleFonts.fredoka(color: Colors.blue[900]),
              ),
              trailing: Switch(
                value: _isNotificationsOn,
                onChanged: (bool value) {
                  setState(() {
                    _isNotificationsOn = value;
                    _updatePreference('isNotificationsOn', value);
                  });
                },
                activeColor: Colors.blue[900],
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Change Theme',
                style: GoogleFonts.fredoka(color: Colors.blue[900]),
              ),
              trailing: Icon(Icons.color_lens, color: Colors.blue[900]),
              onTap: () {
                _showThemeBottomSheet(context);
              },
            ),
            Divider(),
            ElevatedButton(
              onPressed: () {
                //TODO: Add functionality for resetting data
              },
              child: Text('Reset Data', style: GoogleFonts.fredoka(color: Colors.white)),
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
