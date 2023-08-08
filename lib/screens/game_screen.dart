import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:technomaths/enums/game_mode.dart';
import 'package:technomaths/enums/game_speed.dart';
import 'package:technomaths/enums/number_length.dart';


class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final GameSpeed gameSpeed;
  final NumberLength numberLength;

  GameScreen({
    Key? key,
    required this.gameMode,
    required this.gameSpeed,
    required this.numberLength
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String question = '';
  List<String> options = [];
  int score = 0;
  int correctAnswer = 0;
  int lives = 3;
  int remainingTime = 10;
  Timer? timer;
  Key key = UniqueKey();

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void generateQuestion() {
    //cancel the old timer if its still running
    timer?.cancel();

    if (lives <= 0) {
      return;
    }

    var rng = new Random();
    int number1, number2;
    String operator;

    switch(widget.numberLength) {
      case NumberLength.Short:
        number1 = rng.nextInt(10) + 1;
        number2 = rng.nextInt(10) + 1;
        break;
      case NumberLength.Medium:
        number1 = rng.nextInt(100) + 1;
        number2 = rng.nextInt(100) + 1;
        break;
      case NumberLength.Long:
        number1 = rng.nextInt(1000) + 1;
        number2 = rng.nextInt(1000) + 1;
        break;
    }

    List<String> operators = ['+', '-', '×', '÷'];

    switch(widget.gameMode) {
      case GameMode.Addition:
        operator = '+';
        correctAnswer = number1 + number2;
        break;
      case GameMode.Subtraction:
        operator = '-';
        correctAnswer = number1 - number2;
        break;
      case GameMode.Multiplication:
        operator = '×';
        correctAnswer = number1 * number2;
        break;
      case GameMode.Division:
        operator = '÷';
        correctAnswer = (number1 / number2).floor();  // If it's division, take the floor (integer part) of the division
        break;
      case GameMode.All: // In case of 'All', pick a random operator
        operator = operators[rng.nextInt(operators.length)];
        correctAnswer = calculateAnswer(operator, number1, number2);  // Define a function to calculate the answer based on the operator
        break;
    }

    options = generateOptions(correctAnswer);  // Generate four options

    setState(() {
      question = '$number1 $operator $number2';
    });

    // After generating a new question, start the timer again
    startTimer();
  }

  // A function to calculate the correct answer
  int calculateAnswer(String operator, int number1, int number2) {
    switch(operator) {
      case '+':
        return number1 + number2;
      case '-':
        return number1 - number2;
      case '×':
        return number1 * number2;
      case '÷':
        return (number1 / number2).floor();
      default:
        return 0;
    }
  }

  // A function to generate four options
  List<String> generateOptions(int correctAnswer) {
    var rng = new Random();
    Set<String> optionsSet = {};
    optionsSet.add(correctAnswer.toString());  // Add correct answer to options

    while (optionsSet.length < 4) {
      // Generate a number in the range (correctAnswer - 10, correctAnswer + 10)
      int option = correctAnswer + rng.nextInt(21) - 10;
      optionsSet.add(option.toString());
    }

    // Convert the set to a list and shuffle it to randomize the order of options
    List<String> optionsList = optionsSet.toList();
    optionsList.shuffle();
    return optionsList;
  }

  // Add a checkAnswer function to update the score
  void checkAnswer(String selectedOption, int correctAnswer) {
    // Cancel the timer regardless of the correctness of the answer
    timer?.cancel();

    if (selectedOption == correctAnswer.toString()) {
      setState(() {
        score++;
      });
      generateQuestion();
    } else {
      setState(() {
        lives--;
      });

      // If game isn't over, generate a new question
      if (lives > 0){
        generateQuestion();
      }
    }
  }

  void startTimer() {
    remainingTime = 10; // Reset the remaining time
    key = UniqueKey(); // Generate a new Key

    const oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (remainingTime <= 0) {
            timer.cancel();
            endOfTimer();
          } else {
            remainingTime -= 1;
          }
        },
      ),
    );
  }

  void endOfTimer() {
    if(lives > 1) {
      setState(() {
        lives--;
      });
      generateQuestion();
    } else if (lives == 1) { // This condition will handle when lives are exactly 1
      setState(() {
        lives = 0; // Ensure lives are set to 0
      });
      timer?.cancel();
    }
    else {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Main game screen
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            // Timer Text
                            Text(
                              '$remainingTime s',
                              style: TextStyle(
                                color: Colors.purple[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            // Spacer for a gap between text and progress bar
                            SizedBox(height: 10),
                            // Progress bar
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20), // Padding for wider bar
                              height: 30, // Height for progress bar
                              child: TweenAnimationBuilder(
                                key: key,
                                tween: Tween(begin: 1.0, end: 0.0),
                                duration: Duration(seconds: remainingTime),
                                builder: (context, value, child) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    minHeight: 30, // Increase height of progress bar
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[700]!),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(lives, (index) => Icon(Icons.favorite, color: Colors.purple, size: 40)).toList(),
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: Text(
                            'Score: $score',
                            style: TextStyle(color: Colors.purple, fontSize: 32),
                          ),
                        ),
                        SizedBox(height: 50),
                        Text(
                          question,
                          style: TextStyle(fontSize: 50, color: Colors.purple),
                        ),
                        SizedBox(height: 30),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                          padding: const EdgeInsets.all(20),
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          children: <Widget>[
                            AnimatedButton(options[0], onPressed: () => checkAnswer(options[0],correctAnswer)),
                            AnimatedButton(options[1], onPressed: () => checkAnswer(options[1],correctAnswer)),
                            AnimatedButton(options[2], onPressed: () => checkAnswer(options[2],correctAnswer)),
                            AnimatedButton(options[3], onPressed: () => checkAnswer(options[3],correctAnswer)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Game Over overlay
          if (lives == 0) ...[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  title: Text('Game Over', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 32)),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('Your Name', textAlign: TextAlign.center,),
                        TextField(
                          textAlign: TextAlign.center,
                        ),  // User can enter their name here
                        SizedBox(height: 20),
                        Text('Your Score: $score', textAlign: TextAlign.center, style: TextStyle(color: Colors.purple, fontSize: 24)),
                        SizedBox(height: 20),
                        Text('Best Score: $score', textAlign: TextAlign.center, style: TextStyle(color: Colors.purple, fontSize: 24)),  // Keeping current score as best score for now
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameScreen(
                                  gameMode: widget.gameMode,
                                  gameSpeed: widget.gameSpeed,
                                  numberLength: widget.numberLength,
                                ),
                              ),
                            );
                          },
                          child: Text('Retry', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple, // This replaces the 'color' property
                            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50), // Button size is 40% of screen width and has a fixed height of 50.
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},  // Add functionality to go to Wall of Fame
                          child: Text('Wall of Fame', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple, // This replaces the 'color' property
                            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50), // Button size is 40% of screen width and has a fixed height of 50.
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},  // Add functionality to go to Rate screen
                          child: Text('Rate the Game', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple, // This replaces the 'color' property
                            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50), // Button size is 40% of screen width and has a fixed height of 50.
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}