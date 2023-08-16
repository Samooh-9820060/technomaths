import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';  // import this
import 'package:technomaths/utils/commonFunctions.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:technomaths/screens/game_screen.dart';
import 'package:technomaths/config/game_mode.dart';
import 'package:technomaths/config/game_speed.dart';


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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueAccent, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose Endless Mode',
              style: GoogleFonts.fredoka(fontSize: 30, color: Colors.blueAccent), // Use Google font here
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
            AnimatedButton('All', onPressed: () async {
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
