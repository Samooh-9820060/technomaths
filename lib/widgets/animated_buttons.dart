import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  AnimatedButton(this.text, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 360 ? 16 : 20;  // Adjust values as per your needs

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: screenWidth * 0.5,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // Reduced padding
            primary: Colors.purple,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 10,
          ),
          onPressed: onPressed,
          child: FittedBox(
            fit: BoxFit.fitWidth, // This line ensures the content scales correctly.
            child: Text(
              text,
              style: GoogleFonts.fredoka(fontSize: fontSize, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
