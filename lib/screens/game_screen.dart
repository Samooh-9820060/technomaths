import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technomaths/screens/wall_of_fame.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:technomaths/enums/game_mode.dart';
import 'package:technomaths/enums/game_speed.dart';

import '../database/database_helper.dart';
import '../utils/device_uuid_util.dart';


class GameScreen extends StatefulWidget {
  GameMode gameMode;
  GameSpeed gameSpeed;

  GameScreen({
    Key? key,
    required this.gameMode,
    required this.gameSpeed,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  String question = '';
  List<String> options = [];
  int score = 0;
  dynamic correctAnswer = 0;
  int lives = 3;
  int remainingTime = 0;
  Timer? timer;
  int maxNumber = 9;
  Duration totalTime = Duration(seconds: 0);
  Timer? totalGameTimer;
  int dataSaved = 0;
  int? highestScore;
  bool canRevive = true;
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  final FirebaseFirestore firestore = FirebaseFirestore.instance;



  Key key = UniqueKey();
  // Check if the device can vibrate
  bool _canVibrate = false;
  late AnimationController _scoreController;
  late Animation<double> _scoreAnimation;
  TextEditingController _nameController = TextEditingController();



  @override
  void initState() {
    super.initState();
    _loadPlayerName();
    _loadHighestScore();
    _createRewardedAd();
    generateQuestion();
    _checkVibrationSupport();
    _scoreController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(_scoreController);
    startTotalGameTimer();
    dataSaved = 0;
    canRevive = true;
  }

  Future<String?> getUniqueDeviceID() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      return null;
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          return '${androidInfo.brand}-${androidInfo.model}-${androidInfo.product}-${androidInfo.fingerprint}';
        case TargetPlatform.iOS:
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          return iosInfo.identifierForVendor;
      // Add more platforms if needed.
        default:
          return null;
      }
    }
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-6109906096472807/2881924681'
            : 'ca-app-pub-6109906096472807/2881924681',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {

          //ad viewed
          setState(() {
            lives += 1;   // Award an extra life
            canRevive = false;  // Ensure the user can't revive again until they lose again
            startTimer(); // restart the timer or continue from where it was paused
          });
        });
    _rewardedAd = null;
  }


  Future<void> _loadHighestScore() async {
    final score = await DatabaseHelper.instance.queryHighestScore(widget.gameMode.toString());
    setState(() {
      highestScore = score;
    });
  }

  String getReadableTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigitMinutes}:${twoDigitSeconds}";
  }

  // Asynchronous method to check vibration support
  Future<void> _checkVibrationSupport() async {
    bool vibrationSupported = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = vibrationSupported;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  void startTotalGameTimer() {
    totalGameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        totalTime = totalTime + Duration(seconds: 1);
      });
    });
  }

  void stopTotalGameTimer() {
    totalGameTimer?.cancel();
  }


  void increaseDifficulty() {
    // Increase maxNumber every 5 levels
    if (score <= 10) {
      maxNumber = 4 + score;
    } else if (score <= 30) {
      maxNumber = 25 + score;
    } else if (score <= 50) {
      maxNumber = 80 + score;  // For initial scores, increase by 1 unit.
    } else if (score <= 100) {
      maxNumber = 400 + 2 * (score - 50);  // Increase by 2 units for scores between 50 and 100.
    } else if (score <= 150) {
      maxNumber = 3000 + 5 * (score - 100);  // Increase by 5 units beyond 100.
    } else {
      maxNumber = 10000 + 10 * (score - 150);  // Further increase for high scores.
    }

    // Increase gameSpeed every 2 levels
    if (score  % 10 == 0) {
      switch (widget.gameSpeed) {
        case GameSpeed.fifteen:
          widget.gameSpeed = GameSpeed.fourteen;
          break;
        case GameSpeed.fourteen:
          widget.gameSpeed = GameSpeed.thirteen;
          break;
        case GameSpeed.thirteen:
          widget.gameSpeed = GameSpeed.twelve;
          break;
        case GameSpeed.twelve:
          widget.gameSpeed = GameSpeed.eleven;
          break;
        case GameSpeed.eleven:
          widget.gameSpeed = GameSpeed.ten;
          break;
        case GameSpeed.ten:
          widget.gameSpeed = GameSpeed.nine;
          break;
        case GameSpeed.nine:
          widget.gameSpeed = GameSpeed.eight;
          break;
        case GameSpeed.eight:
          widget.gameSpeed = GameSpeed.seven;
          break;
        case GameSpeed.seven:
          widget.gameSpeed = GameSpeed.six;
          break;
        case GameSpeed.six:
          widget.gameSpeed = GameSpeed.five;
          break;
        case GameSpeed.five:
          widget.gameSpeed = GameSpeed.four;
          break;
        case GameSpeed.four:
          widget.gameSpeed = GameSpeed.three;
          break;
        case GameSpeed.three:
          widget.gameSpeed = GameSpeed.two;
          break;
        case GameSpeed.two:
          widget.gameSpeed = GameSpeed.one;
          break;
        default:
          break;
      }
    }
  }

  void generateQuestion() {
    //cancel the old timer if its still running
    timer?.cancel();

    if (lives <= 0) {
      stopTotalGameTimer();
      return;
    }

    var rng = new Random();
    int number1, number2;
    String operator;

    number1 = rng.nextInt(maxNumber) + 1;
    number2 = rng.nextInt(maxNumber) + 1;

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
        correctAnswer = (number1 / number2);  // If it's division, take the floor (integer part) of the division
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
  dynamic calculateAnswer(String operator, int number1, int number2) {
    switch(operator) {
      case '+':
        return number1 + number2;
      case '-':
        return number1 - number2;
      case '×':
        return number1 * number2;
      case '÷':
        double result = number1.toDouble() / number2.toDouble();
        return result;
      default:
        return 0;
    }
  }

  // A function to generate four options
  List<String> generateOptions(dynamic correctAnswer) {
    var rng = new Random();
    Set<String> optionsSet = {};
    optionsSet.add(correctAnswer.toString());  // Add correct answer to options

    // Check the format of the correct answer
    int decimalCount = 0;
    if (correctAnswer is double) {
      String correctStr = correctAnswer.toString();
      int dotIndex = correctStr.indexOf('.');
      if(dotIndex != -1) {
        decimalCount = correctStr.substring(dotIndex + 1).length;
      }
    }

    // Capture the least significant digit of the correct answer
    int lastDigitOfCorrectAnswer;
    if(correctAnswer is int) {
      lastDigitOfCorrectAnswer = correctAnswer % 10;
    } else {
      double lastDigitDouble = (correctAnswer * 10) % 10;
      lastDigitOfCorrectAnswer = lastDigitDouble.toInt();
    }

    while (optionsSet.length < 4) {
      dynamic option;

      // Generate a number that ends with the same last digit about 50% of the time
      if (rng.nextBool()) {
        if(decimalCount == 0) {
          option = correctAnswer + rng.nextInt(21) - 10;
          option -= option % 10;
          option += lastDigitOfCorrectAnswer;
        } else if(decimalCount == 1) {
          option = (correctAnswer + rng.nextDouble() * 2 - 1).toStringAsFixed(1);
        } else {
          option = (correctAnswer + rng.nextDouble() * 2 - 1).toStringAsFixed(2);
        }
      } else {
        if(decimalCount == 0) {
          option = correctAnswer + rng.nextInt(21) - 10;
        } else if(decimalCount == 1) {
          option = (correctAnswer + rng.nextDouble() * 2 - 1).toStringAsFixed(1);
        } else {
          option = (correctAnswer + rng.nextDouble() * 2 - 1).toStringAsFixed(2);
        }
      }

      optionsSet.add(option.toString());
    }

    // Convert the set to a list and shuffle it to randomize the order of options
    List<String> optionsList = optionsSet.toList();
    optionsList.shuffle();
    return optionsList;
  }

  // Add a checkAnswer function to update the score
  void checkAnswer(String selectedOption, dynamic correctAnswer) {
    // Cancel the timer regardless of the correctness of the answer
    timer?.cancel();

    if (_canVibrate) {
      if (selectedOption == correctAnswer.toString()) {
        Vibrate.feedback(FeedbackType.success);  // Vibrate on correct answer
      } else {
        Vibrate.feedback(FeedbackType.error);    // Vibrate on incorrect answer
      }
    }


    if (selectedOption == correctAnswer.toString()) {
      _scoreController.forward().then((_) {
        _scoreController.reverse();
      });
      setState(() {
        score++;
      });

      increaseDifficulty();
      generateQuestion();
    } else {
      setState(() {
        lives--;
      });

      // If game isn't over, generate a new question
      if (lives > 0){
        generateQuestion();
      } else {
        stopTotalGameTimer();
      }


    }
  }

  void updateRemainingTime(){
    switch(widget.gameSpeed) {
      case GameSpeed.fifteen:
        remainingTime = 15;
        break;
      case GameSpeed.fourteen:
        remainingTime = 14;
        break;
      case GameSpeed.thirteen:
        remainingTime = 13;
        break;
      case GameSpeed.twelve:
        remainingTime = 12;
        break;
      case GameSpeed.eleven:
        remainingTime = 11;
        break;
      case GameSpeed.ten:
        remainingTime = 10;
        break;
      case GameSpeed.nine:
        remainingTime = 9;
        break;
      case GameSpeed.eight:
        remainingTime = 8;
        break;
      case GameSpeed.seven:
        remainingTime = 7;
        break;
      case GameSpeed.six:
        remainingTime = 6;
        break;
      case GameSpeed.five:
        remainingTime = 5;
        break;
      case GameSpeed.four:
        remainingTime = 4;
        break;
      case GameSpeed.three:
        remainingTime = 3;
        break;
      case GameSpeed.two:
        remainingTime = 2;
        break;
      case GameSpeed.one:
        remainingTime = 1;
        break;
      default:
      // Handle any unexpected cases here
        break;
    }
  }

  void startTimer() {

    updateRemainingTime();

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
    Vibrate.feedback(FeedbackType.error);
    if(lives > 1) {
      setState(() {
        lives--;
      });
      generateQuestion();
    } else if (lives == 1) { // This condition will handle when lives are exactly 1
      setState(() {
        lives = 0; // Ensure lives are set to 0
      });
      stopTotalGameTimer();
      timer?.cancel();
    }
    else {
      timer?.cancel();
    }
  }

  void _saveGameData() async {
    if (_nameController.text.trim().isNotEmpty && dataSaved == 0) {

      // Local data saving logic
      Map<String, dynamic> row = {
        DatabaseHelper.columnName: _nameController.text,
        DatabaseHelper.columnScore: score,
        DatabaseHelper.columnGameMode: widget.gameMode.toString(),
        DatabaseHelper.columnTimeElapsed: getReadableTime(totalTime)
      };

      final id = await DatabaseHelper.instance.insert(row);

      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.none) {
        // No internet connection
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot connect to server'))
        );
        return;
      } else {
        // Firebase data saving logic
        CollectionReference games = FirebaseFirestore.instance.collection('endlessModeGameData');
        String? deviceInfo = await getUniqueDeviceID();
        String deviceUID = await DeviceUUIDUtil.getDeviceUUID();

        Map<String, dynamic> firebaseRow = {
          'datetime': DateTime.now().toIso8601String(),  // Save the current date and time as a string in ISO format
          'deviceInfo': deviceInfo,
          'deviceUID': deviceUID,
          'name': _nameController.text,
          'score': score,
          'gameMode': widget.gameMode.toString(),
          'timeElapsed': getReadableTime(totalTime),
        };

        await games.add(firebaseRow);
      }

      dataSaved = 1;
    }

    canRevive = false;
  }

  _loadPlayerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? playerName = prefs.getString('playerName');
    setState(() {
      _nameController.text = playerName ?? '';
    });
  }

  _savePlayerName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('playerName', name);
  }

  String formatDecimal(String value) {
    if (value.contains('.')) {
      return double.parse(value).toStringAsFixed(2);
    }
    return value;  // return as-is if no decimal point
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: lives!= 0 ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ) : null,
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
                            // Total time elapsed display
                            Center(
                              child: Text(
                                'Time: ${getReadableTime(totalTime)}',
                                style: GoogleFonts.aBeeZee(
                                  color: Colors.purple[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            // Spacer for a gap between text and progress bar
                            SizedBox(height: 30),
                            // Progress bar
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 30), // Padding for wider bar
                              height: 10, // Height for progress bar
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
                        SizedBox(height: 30),
                        Center(
                          child: Text(
                            'Score: $score',
                            style: GoogleFonts.fredoka(color: Colors.purple, fontSize: 32),
                          ),
                        ),
                        // Animated score pop-up
                        FadeTransition(
                          opacity: _scoreAnimation,
                          child: Text(
                            '+1',
                            style: GoogleFonts.fredoka(color: Colors.green, fontSize: 32),
                          ),
                        ),

                        SizedBox(height: 30),
                        Text(
                          question.contains('÷') ? formatDecimal(question) : question,  // check if division is present in the question
                          style: GoogleFonts.fredoka(fontSize: 50, color: Colors.purple),
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
                            AnimatedButton(formatDecimal(options[0]), onPressed: () => checkAnswer(options[0], correctAnswer)),
                            AnimatedButton(formatDecimal(options[1]), onPressed: () => checkAnswer(options[1], correctAnswer)),
                            AnimatedButton(formatDecimal(options[2]), onPressed: () => checkAnswer(options[2], correctAnswer)),
                            AnimatedButton(formatDecimal(options[3]), onPressed: () => checkAnswer(options[3], correctAnswer)),
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
                  title: Text('Game Over', textAlign: TextAlign.center, style: GoogleFonts.fredoka(color: Colors.red, fontSize: 32)),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('Your Name', textAlign: TextAlign.center,),
                        TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _savePlayerName(value);
                          },
                        ),  // User can enter their name here
                        SizedBox(height: 20),
                        Text('Your Score: $score', textAlign: TextAlign.center, style: GoogleFonts.fredoka(color: Colors.purple, fontSize: 24)),
                        SizedBox(height: 20),
                        Text('Best Score: $highestScore', textAlign: TextAlign.center, style: GoogleFonts.fredoka(color: Colors.purple, fontSize: 24)),
                        SizedBox(height: 30),
                        if (canRevive && _rewardedAd != null) ...[
                          ElevatedButton(
                            onPressed: () {
                              _showRewardedAd();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow, color: Colors.white),  // Representing a video play button
                                SizedBox(width: 10),
                                Text('Revive', style: GoogleFonts.fredoka(color: Colors.white, fontSize: 18)),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[500],
                              onPrimary: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                        ElevatedButton(
                          onPressed: () {
                            _saveGameData();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameScreen(
                                  gameMode: widget.gameMode,
                                  gameSpeed: GameSpeed.fifteen,
                                ),
                              ),
                            );
                          },
                          child: Text('Retry', style: GoogleFonts.fredoka(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple, // This replaces the 'color' property
                            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50), // Button size is 40% of screen width and has a fixed height of 50.
                          ),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            _saveGameData();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => WallOfFameScreen(
                              gameMode: widget.gameMode,
                            )));
                          },  // Add functionality to go to Wall of Fame
                          child: Text('Wall of Fame', style: GoogleFonts.fredoka(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple, // This replaces the 'color' property
                            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50), // Button size is 40% of screen width and has a fixed height of 50.
                          ),
                        ),

                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context), // Add functionality to go to Rate screen
                          child: Text('Back', style: GoogleFonts.fredoka(color: Colors.white)),
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