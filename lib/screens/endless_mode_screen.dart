import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:technomaths/screens/game_screen.dart';
import 'package:technomaths/enums/game_mode.dart';
import 'package:technomaths/enums/game_speed.dart';

import '../themes/theme_data.dart'; // Import your theme data

class EndlessModeScreen extends StatelessWidget {
  const EndlessModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);

    // Determine which custom theme is currently active
    CustomTheme? activeTheme;
    for (var theme in AppThemes.themes.entries) {
      if (theme.value.themeData.primaryColor == currentTheme.primaryColor) {
        activeTheme = theme.key;
        break;
      }
    }

    LinearGradient? backgroundGradient = activeTheme != null
        ? AppThemes.buttonGradients[activeTheme]
        : LinearGradient(colors: [Colors.grey, Colors.grey]);  // Default to a grey gradient if theme is undetermined

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: currentTheme.colorScheme.secondary, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              currentTheme.primaryColor.withOpacity(0.8),
              currentTheme.colorScheme.secondary.withOpacity(0.1)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                child: ShaderMask(
                  shaderCallback: (bounds) => backgroundGradient?.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height))
                      ?? LinearGradient(colors: [Colors.transparent]).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text(
                    'Choose Mode',
                    style: GoogleFonts.fredoka(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
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
