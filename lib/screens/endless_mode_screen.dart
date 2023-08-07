import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  // import this
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:technomaths/screens/game_screen.dart';
import 'package:technomaths/enums/game_mode.dart';
import 'package:technomaths/enums/game_speed.dart';
import 'package:technomaths/enums/number_length.dart';


class EndlessModeScreen extends StatelessWidget {
  const EndlessModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"), // Assuming you have a background image in your assets
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Choose Endless Mode',
                style: GoogleFonts.fredoka(fontSize: 30, color: Colors.purple), // Use Google font here
              ),
              SizedBox(height: 30),
              AnimatedButton('Addition', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                        gameMode: GameMode.Addition,
                        gameSpeed: GameSpeed.Slow,
                        numberLength: NumberLength.Short
                    ),
                  ),
                );
              }),
              AnimatedButton('Subtraction', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                        gameMode: GameMode.Subtraction,
                        gameSpeed: GameSpeed.Slow,
                        numberLength: NumberLength.Short
                    ),
                  ),
                );
              }),
              AnimatedButton('Multiplication', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                        gameMode: GameMode.Multiplication,
                        gameSpeed: GameSpeed.Slow,
                        numberLength: NumberLength.Short
                    ),
                  ),
                );
              }),
              AnimatedButton('Division', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                        gameMode: GameMode.Division,
                        gameSpeed: GameSpeed.Slow,
                        numberLength: NumberLength.Short
                    ),
                  ),
                );
              }),
              AnimatedButton('All', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                        gameMode: GameMode.All,
                        gameSpeed: GameSpeed.Slow,
                        numberLength: NumberLength.Short
                    ),
                  ),
                );
              }),
              AnimatedButton('Back', onPressed: () {
                Navigator.pop(context);  // Go back to the previous screen
              }),
            ],
          ),
        ),
      ),
    );
  }
}
