import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/config/ThemeHelper.dart';
import 'package:technomaths/levels/2.%20Basic%20Arithmetic/Counting%20Numbers/1.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeHelper = ThemeHelper(context);

    return Scaffold(
      backgroundColor: themeHelper.primaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),  // Replace with your image
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 20,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to TechnoMath',
                        style: GoogleFonts.orbitron(
                          fontSize: 26,
                          color: themeHelper.btnTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'About TechnoMath',
                        style: GoogleFonts.orbitron(
                          fontSize: 18,
                          color: themeHelper.btnTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Embark on a journey of mathematical discovery and skill-building. From basic arithmetic to complex equations, TechnoMath offers a comprehensive and engaging experience.',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: themeHelper.btnTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => lvl1(),
                            ),
                          );
                        },
                        child: Text(
                          'Begin!',
                          style: GoogleFonts.orbitron(
                            fontSize: 20,
                            color: themeHelper.btnTextColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: themeHelper.buttonIndicatorColor,
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
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
