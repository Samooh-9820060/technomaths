import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:technomaths/screens/game_screen.dart';
import 'package:technomaths/enums/game_mode.dart';
import 'package:technomaths/enums/game_speed.dart';

class EndlessModeScreen extends StatelessWidget {
  const EndlessModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple, size: 30), // adjusted color to fit the design
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent.withOpacity(0.9), Colors.deepPurple.withOpacity(0.2)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.deepPurple, Colors.blue],
                  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text(
                    'Choose Mode',
                    style: GoogleFonts.fredoka(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Using shader mask to apply gradient
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              AnimatedButton('Addition', onPressed: () {
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
              AnimatedButton('Subtraction', onPressed: () {
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
              AnimatedButton('Multiplication', onPressed: () {
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
              AnimatedButton('Division', onPressed: () {
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
              AnimatedButton('All', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      gameMode: GameMode.All,
                      gameSpeed: GameSpeed.fifteen,
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