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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Choose Endless Mode',
                style: GoogleFonts.fredoka(fontSize: 30, color: Colors.purple), // Use Google font here
              ),
              SizedBox(height: 50),
              AnimatedButton('Addition', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                        gameMode: GameMode.Addition,
                        gameSpeed: GameSpeed.fifteen,
                        numberLength: NumberLength.one
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
                        gameSpeed: GameSpeed.fifteen,
                        numberLength: NumberLength.one
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
                        gameSpeed: GameSpeed.fifteen,
                        numberLength: NumberLength.one
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
                        gameSpeed: GameSpeed.fifteen,
                        numberLength: NumberLength.one
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
                        gameSpeed: GameSpeed.fifteen,
                        numberLength: NumberLength.one
                    ),
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
