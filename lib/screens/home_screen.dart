import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technomaths/config/ThemeHelper.dart';
import 'package:technomaths/config/extended_theme.dart';
import 'package:technomaths/screens/levels_screen.dart';
import 'package:technomaths/screens/settings.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:flutter/services.dart';
import 'package:technomaths/screens/endless_mode_screen.dart';
import 'package:technomaths/config/extended_theme.dart';
import '../config/theme_notifier.dart';
import '../config/themes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _checkAndShowNameDialog();
    });
  }

  Future<void> _checkAndShowNameDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? playerName = prefs.getString('playerName');
    if (playerName == null || playerName.isEmpty) {
      _showNameDialog();
    }
  }

  void _showNameDialog() {
    final TextEditingController _nameController = TextEditingController();
    final themeColors = ThemeHelper(context); // Assuming you have a ThemeHelper
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ), // this right here
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(6, 20, 6, 0),
                  child: Center(
                    child: Text(
                      "Enter Your Name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: themeColors.headerColor),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 200,
                    child: TextField(
                      controller: _nameController,
                      maxLength: 12,
                      decoration: InputDecoration(
                        counterText: "",
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          filled: true,
                          prefixIcon: Icon(Icons.person)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text.length > 2) {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('playerName', _nameController.text);
                        Navigator.pop(context);
                      } else {
                        // Show a message or do something to inform the user
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Enter a valid name'),
                          ),
                        );
                      }
                    },
                    child: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // 20 is the radius value
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> performVibration() async {
    bool canVibrate = await commonFunctions.checkVibrationSupport();
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.medium); // You can adjust the feedback type as per your preference.
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeHelper(context);
    return Scaffold(
      body: Container(
        decoration: themeColors.currentTheme.backgroundDecoration(false),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'TechnoMaths',
                style: GoogleFonts.fredoka(fontSize: 40, color: themeColors.headerColor),
              ),
              SizedBox(height: 50), // Add this for extra space
              /*AnimatedButton('Levels', onPressed: () async {
                await performVibration();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LevelsJourneyScreen()),
                );
              }),*/
              AnimatedButton('Endless', onPressed: () async {
                await performVibration();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EndlessModeScreen()),
                );
              }),
              //AnimatedButton('Levels', onPressed: () {
                // Code to go to the levels
              //}),
              /*AnimatedButton('Test Button', onPressed: () async {
                //await devUseMethods.addMessagesInBulk();
                final notificationService = NotificationService();
                await notificationService.initialize();
              }),*/
              AnimatedButton('Settings', onPressed: () async {
                await performVibration();
                // Settings code
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              }),
              AnimatedButton('Quit', onPressed: () async {
                await performVibration();
                SystemNavigator.pop();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
