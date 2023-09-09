import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:technomaths/config/ThemeHelper.dart';
import 'package:technomaths/utils/commonFunctions.dart';

class lvl1 extends StatefulWidget {
  @override
  _lvl1State createState() => _lvl1State();
}

class _lvl1State extends State<lvl1> {
  bool _showQuiz = false;

  Future<void> performVibration() async {
    bool canVibrate = await commonFunctions.checkVibrationSupport();
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.medium);
    }
  }

  Widget futuristicButton(
      {required String label,
      required Function onPressed,
      required Color color}) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(label,
          style: TextStyle(
              fontFamily: 'Orbitron', fontSize: 16, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget learningPhase() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'The Mystical Forest of TechnoMath',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 28,
              color: Colors.cyanAccent,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.cyanAccent, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  'In a realm beyond our own, Neo finds himself in a forest glowing with neon lights. The trees here aren’t ordinary, they shimmer and change colors!',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'An enigmatic figure named Sage, with circuits running through him, appears. "Neo," he whispers, "This forest hides a secret code. Decipher it, and you'
                  'll unlock the powers of arithmetic."',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'The trees bear fruits in patterns, and Neo realizes that by understanding these patterns, he might just find the code Sage mentioned.',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          futuristicButton(
              label: 'Begin the Quest!',
              onPressed: () {
                setState(() {
                  _showQuiz = true;
                });
              },
              color: Colors.blueAccent),
        ],
      ),
    );
  }

  Widget quizPhase() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Quiz: How many apples in total?',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 24,
            color: Colors.cyanAccent,
          ),
        ),
        SizedBox(height: 20),
        futuristicButton(
            label: '5 apples',
            onPressed: () {
              // Logic for correct answer
            },
            color: Colors.green),
        SizedBox(height: 10),
        futuristicButton(
            label: '4 apples',
            onPressed: () {
              // Logic for incorrect answer
            },
            color: Colors.red),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Level 1',
            style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 24,
                color: Colors.cyanAccent)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.cyanAccent, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: _showQuiz ? quizPhase() : learningPhase(),
            ),
          ],
        ),
      ),
    );
  }
}