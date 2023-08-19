import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';  // import this
import 'package:provider/provider.dart';
import 'package:technomaths/screens/wall_of_fame.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:technomaths/screens/game_screen.dart';
import 'package:technomaths/config/game_mode.dart';
import 'package:technomaths/config/game_speed.dart';

import '../config/theme_notifier.dart';
import '../config/themes.dart';
import 'home_screen.dart';


class EndlessModeScreen extends StatelessWidget {
  const EndlessModeScreen({Key? key}) : super(key: key);

  Future<void> performVibration() async {
    bool canVibrate = await commonFunctions.checkVibrationSupport();
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.medium); // You can adjust the feedback type as per your preference.
    }
  }

  @override
  Widget build(BuildContext context) {

    Color secondaryColor = themes[Provider.of<ThemeNotifier>(context).currentThemeKey]!.themeData.colorScheme.secondary;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryColor, size: 30),
          onPressed: () async {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen())
            );
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0), // Adjust the horizontal padding as needed
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.trophy, color: secondaryColor, size: 30),
              onPressed: () async {
                await performVibration();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WallOfFameScreen(
                    gameMode: GameMode.Addition,
                  ),
                ));
              },
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose Endless Mode',
              style: GoogleFonts.fredoka(fontSize: 30, color: secondaryColor), // Use Google font here
            ),
            const SizedBox(height: 50),
            AnimatedButton('Addition', onPressed: () async {
              await performVibration();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                      gameMode: GameMode.Addition,
                      gameSpeed: GameSpeed.fifteen,
                  ),
                ),
              );
            }),
            AnimatedButton('Subtraction', onPressed: () async {
              await performVibration();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                      gameMode: GameMode.Subtraction,
                      gameSpeed: GameSpeed.fifteen,
                  ),
                ),
              );
            }),
            AnimatedButton('Multiplication', onPressed: () async {
              await performVibration();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                      gameMode: GameMode.Multiplication,
                      gameSpeed: GameSpeed.fifteen,
                  ),
                ),
              );
            }),
            AnimatedButton('Division', onPressed: () async {
              await performVibration();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                      gameMode: GameMode.Division,
                      gameSpeed: GameSpeed.fifteen,
                  ),
                ),
              );
            }),
            AnimatedButton('Mix', onPressed: () async {
              await performVibration();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                      gameMode: GameMode.Mix,
                      gameSpeed: GameSpeed.fifteen,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
