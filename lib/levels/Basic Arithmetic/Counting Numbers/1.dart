import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technomaths/config/ThemeHelper.dart';
import 'package:technomaths/utils/commonFunctions.dart';

class lvl1 extends StatefulWidget {
  @override
  _lvl1State createState() => _lvl1State();
}

class _lvl1State extends State<lvl1> with SingleTickerProviderStateMixin {
  bool _showQuiz = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future<void> performVibration() async {
    bool canVibrate = await commonFunctions.checkVibrationSupport();
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.medium);
    }
  }

  Widget learningPhase() {
    final themeColors = ThemeHelper(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _animation,
            child: Text(
              'The Magical Forest of TechnoMath',
              style: GoogleFonts.pacifico(
                fontSize: 34,
                color: themeColors.headerColor,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.blue,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          FadeTransition(
            opacity: _animation,
            child: Text(
              'Neo enters a vibrant forest. Here, trees bear fruits in mysterious patterns. An old Numeling named Sage approaches and says, "Understanding these patterns is the first step towards mastering arithmetic. Let\'s begin with counting."',
              style: TextStyle(
                fontSize: 20,
                color: themeColors.textColor,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showQuiz = true;
              });
            },
            child: Text('Help Neo Count!'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              primary: themeColors.btnTextColor,
              onPrimary: Colors.white,
              textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: themeColors.headerColor, width: 2),
              ),
              shadowColor: Colors.blueAccent,
              elevation: 5.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget quizPhase() {
    final themeColors = ThemeHelper(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Quiz: If there are 3 apples on one tree and 2 on another, how many apples are there in total?',
          style: TextStyle(
            fontSize: 26,
            color: themeColors.headerColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Logic for correct answer
          },
          child: Text('5 apples'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            primary: themeColors.btnTextColor,
            onPrimary: Colors.white,
            textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: themeColors.headerColor, width: 2),
            ),
            shadowColor: Colors.greenAccent,
            elevation: 5.0,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Logic for incorrect answer
          },
          child: Text('4 apples'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            primary: themeColors.btnTextColor,
            onPrimary: Colors.white,
            textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: themeColors.headerColor, width: 2),
            ),
            shadowColor: Colors.redAccent,
            elevation: 5.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeHelper(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Level 1', style: GoogleFonts.fredoka(fontSize: 26, color: themeColors.headerColor)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeColors.iconColor, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.lightBlueAccent.withOpacity(0.7),
              Colors.purpleAccent.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _showQuiz ? quizPhase() : learningPhase(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
