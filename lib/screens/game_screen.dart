import 'dart:math';
import 'package:flutter/material.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:technomaths/enums/game_mode.dart';
import 'package:technomaths/enums/game_speed.dart';
import 'package:technomaths/enums/number_length.dart';


class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final GameSpeed gameSpeed;
  final NumberLength numberLength;

  GameScreen({Key? key, required this.gameMode, required this.gameSpeed, required this.numberLength}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String question = '';
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    var rng = new Random();
    int number1, number2, correctAnswer;
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

    List<String> operators = ['+', '-', '*', '/'];

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
        operator = '*';
        correctAnswer = number1 * number2;
        break;
      case GameMode.Division:
        operator = '/';
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
  }

  // A function to calculate the correct answer
  int calculateAnswer(String operator, int number1, int number2) {
    switch(operator) {
      case '+':
        return number1 + number2;
      case '-':
        return number1 - number2;
      case '*':
        return number1 * number2;
      case '/':
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Score: 0',
                        style: TextStyle(color: Colors.purple, fontSize: 32),
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      question,
                      style: TextStyle(fontSize: 50, color: Colors.purple),
                    ),
                    SizedBox(height: 50),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                      padding: const EdgeInsets.all(20),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: <Widget>[
                        AnimatedButton(options[0], onPressed: () {}),
                        AnimatedButton(options[1], onPressed: () {}),
                        AnimatedButton(options[2], onPressed: () {}),
                        AnimatedButton(options[3], onPressed: () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
