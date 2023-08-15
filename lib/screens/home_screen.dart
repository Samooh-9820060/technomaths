import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/enums/game_mode.dart';
import 'package:technomaths/screens/settings_page.dart';
import 'package:technomaths/screens/wall_of_fame.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:flutter/services.dart'; // Required for SystemNavigator
import 'package:technomaths/screens/endless_mode_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'TechnoMaths',
                    style: GoogleFonts.fredoka(
                        fontSize: 40, fontWeight: FontWeight.w500, color: Colors.white,
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
              AnimatedButton('Endless', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EndlessModeScreen()),
                );
              }),
              AnimatedButton('Wall of Fame', onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WallOfFameScreen(
                      gameMode: GameMode.Addition,
                    )));
              }),
              AnimatedButton('Rate the Game', onPressed: () {
                // Code to rate the game
              }),
              AnimatedButton('Settings', onPressed: () {
                //Settings screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              }),
              AnimatedButton('Quit', onPressed: () {
                SystemNavigator.pop();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
