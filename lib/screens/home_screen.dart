import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/enums/game_mode.dart';
import 'package:technomaths/screens/settings_page.dart';
import 'package:technomaths/screens/wall_of_fame.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:flutter/services.dart'; // Required for SystemNavigator
import 'package:technomaths/screens/endless_mode_screen.dart';

import '../themes/theme_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              currentTheme.primaryColor.withOpacity(0.8),  // Lightened this opacity a bit
              currentTheme.colorScheme.secondary.withOpacity(0.1)  // Lightened this opacity more
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
                  shaderCallback: (bounds) =>
                  backgroundGradient?.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height))
                      ?? LinearGradient(colors: [Colors.transparent]).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text(
                    'TechnoMaths',
                    style: currentTheme.textTheme.displayLarge?.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: currentTheme.colorScheme.onPrimary,
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
