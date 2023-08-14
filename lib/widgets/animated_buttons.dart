import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/theme_data.dart';

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  AnimatedButton(this.text, {required this.onPressed});

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

    LinearGradient gradient = activeTheme != null
        ? AppThemes.buttonGradients[activeTheme]!
        : LinearGradient(colors: [Colors.grey, Colors.grey]);  // Default to a grey gradient if theme is undetermined

    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 360 ? 16 : 20;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: screenWidth * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  text,
                  style: GoogleFonts.fredoka(
                    fontSize: fontSize,
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
          ),
        ),
      ),
    );
  }
}
