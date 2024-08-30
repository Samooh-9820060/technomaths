import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';  // import this
import 'package:technomaths/config/ThemeHelper.dart';
import 'package:technomaths/screens/wall_of_fame.dart';
import 'package:technomaths/utils/commonFunctions.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:technomaths/screens/game_screen.dart';
import 'package:technomaths/config/game_mode.dart';
import 'package:technomaths/config/game_speed.dart';
import 'home_screen.dart';
import 'math_crossword_puzzle.dart';


class PuzzleModesScreen extends StatelessWidget {
  const PuzzleModesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeHelper(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeColors.iconColor, size: 30),
          onPressed: () async {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen())
            );
          },
        ),
        /*actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0), // Adjust the horizontal padding as needed
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.trophy, color: themeColors.iconColor, size: 30),
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
        ],*/
      ),
      body: Container(
        decoration: themeColors.currentTheme.backgroundDecoration(false),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Choose Puzzle Type',
                style: GoogleFonts.fredoka(fontSize: 30, color: themeColors.headerColor), // Use Google font here
              ),
              const SizedBox(height: 50),
              AnimatedButton('Math Crossword', onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MathCrosswordPuzzleSettings(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
