import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:technomaths/models/custom_theme_Data.dart';
import '../themes/theme_data.dart';
import '../utils/theme_notifier.dart';

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
            ...AppThemes.themes.entries.map((themeEntry) => ListTile(
              title: Text('${themeEntry.key.toString().split('.').last} Theme', style: GoogleFonts.fredoka(color: Colors.blue[900])),
                onTap: () {
                  var themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
                  themeNotifier.setTheme(themeEntry.value); // Use the CustomThemeData directly from the themeEntry
                  Navigator.pop(context);
                },
            )).toList(),
          ],
        ),
      );
    },
  );
}


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.fredoka(fontSize: 22)), // Use a different font
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                currentTheme.primaryColor,
                currentTheme.colorScheme.secondary
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: currentTheme.colorScheme.background,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            ListTile(
              title: Text(
                'Vibration',
                style: GoogleFonts.fredoka(color: currentTheme.textTheme.displayLarge?.color),
              ),
              trailing: Switch(
                value: true, // TODO: Bind this to your actual settings variable
                onChanged: (bool value) {
                  // TODO: Handle the value change
                },
                activeColor: currentTheme.primaryColor,
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Notifications',
                style: GoogleFonts.fredoka(color: currentTheme.textTheme.displayLarge?.color),
              ),
              trailing: Switch(
                value: true, // TODO: Bind this to your actual settings variable
                onChanged: (bool value) {
                  // TODO: Handle the value change
                },
                activeColor: currentTheme.primaryColor,
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Change Theme',
                style: GoogleFonts.fredoka(color: currentTheme.textTheme.displayLarge?.color),
              ),
              trailing: Icon(Icons.color_lens, color: currentTheme.primaryColor),
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
                backgroundColor: Colors.red[500], // Red, as resetting can be a critical action.
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50), // Button size is 40% of screen width and has a fixed height of 50.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
