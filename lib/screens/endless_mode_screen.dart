import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  // import this
import 'package:technomaths/widgets/animated_buttons.dart';

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
                // Code to start Addition mode
              }),
              AnimatedButton('Subtraction', onPressed: () {
                // Code to start Subtraction mode
              }),
              AnimatedButton('Multiplication', onPressed: () {
                // Code to start Multiplication mode
              }),
              AnimatedButton('All', onPressed: () {
                // Code to start All mode
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
