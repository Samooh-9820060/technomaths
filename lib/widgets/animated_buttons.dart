import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/theme_notifier.dart';
import '../config/themes.dart';

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double verticalPadding;

  AnimatedButton(this.text, {required this.onPressed, this.verticalPadding = 20.0});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 360 ? 16 : 20;  // Adjust values as per your needs
    Color textColor = themes[Provider.of<ThemeNotifier>(context).currentThemeKey]!.btnTextColor;
    Color btnPrimary = themes[Provider.of<ThemeNotifier>(context).currentThemeKey]!.themeData.colorScheme.primary;
    Color btnSecondary = themes[Provider.of<ThemeNotifier>(context).currentThemeKey]!.themeData.colorScheme.secondary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: screenWidth * 0.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [btnPrimary, btnSecondary],
          ),
          borderRadius: BorderRadius.circular(10),  // To match the button's border radius
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: verticalPadding), // Reduced padding
            primary: Colors.transparent, // This will ensure the gradient shows
            onPrimary: textColor,
            shadowColor: Colors.transparent, // No shadow since we already have elevation from the container
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: FittedBox(
            fit: BoxFit.fitWidth, // This line ensures the content scales correctly.
            child: Text(
              text,
              style: GoogleFonts.fredoka(fontSize: fontSize, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
