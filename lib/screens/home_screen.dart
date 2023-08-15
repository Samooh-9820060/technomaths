import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/enums/game_mode.dart';
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'TechnoMaths',
                style: GoogleFonts.fredoka(fontSize: 40, color: Colors.purple),
              ),
              SizedBox(height: 50), // Add this for extra space
              AnimatedButton('Endless', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EndlessModeScreen()),
                );
              }),
              //AnimatedButton('Levels', onPressed: () {
                // Code to go to the levels
              //}),
              AnimatedButton('Wall of Fame', onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WallOfFameScreen(
                      gameMode: GameMode.Addition,
                    )));
              }),
              AnimatedButton('Rate the Game', onPressed: () {
                // Code to go to the wall of fame
              }),
              AnimatedButton('Quit', onPressed: () {
                // Code to quit the app
                SystemNavigator.pop();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
