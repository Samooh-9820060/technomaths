import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                // TODO: Apply Light Theme
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Dark Theme', style: GoogleFonts.fredoka(color: Colors.blue[900])),
              onTap: () {
                // TODO: Apply Dark Theme
                Navigator.pop(context);
              },
            ),
            // Add more theme options if you wish
          ],
        ),
      );
    },
  );
}


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Gradient start color
        title: Text('Settings', style: GoogleFonts.fredoka(fontSize: 22)), // Use a different font
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
        color: Colors.blue[100],
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            ListTile(
              title: Text(
                'Vibration',
                style: GoogleFonts.fredoka(color: Colors.blue[900]),
              ),
              trailing: Switch(
                value: true, // TODO: Bind this to your actual settings variable
                onChanged: (bool value) {
                  // TODO: Handle the value change
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
                value: true, // TODO: Bind this to your actual settings variable
                onChanged: (bool value) {
                  // TODO: Handle the value change
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
                primary: Colors.red[500], // Red, as resetting can be a critical action.
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
