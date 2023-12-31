import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technomaths/screens/wall_of_fame.dart';
import 'package:technomaths/widgets/animated_buttons.dart';
import 'package:technomaths/config/game_mode.dart';
import 'package:technomaths/config/game_speed.dart';
import '../config/ThemeHelper.dart';
import '../config/ad_config.dart';
import '../database/database_helper.dart';
import '../utils/commonFunctions.dart';
import 'endless_mode_screen.dart';

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

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  Future<void>? _initialization;

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
  static const int maxFailedLoadAttemptsRewarded = 3;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttemptsInterstitial = 3;
  Color _backgroundColor = Colors.transparent;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Key key = UniqueKey();
  bool _canVibrate = false;
  late AnimationController _scoreController;
  late Animation<double> _scoreAnimation;
  TextEditingController _nameController = TextEditingController();
  late var themeColors;
  DocumentReference? savedDocument;
  int? savedRowId;


  @override
  void initState() {
    super.initState();
    // Set up other synchronous initializations here, if any
    _scoreController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(_scoreController);

    // Call your async initialization function
    _initialization = initAsync();
  }

  Future<void> initAsync() async {
    await _loadPlayerName();
    await _loadHighestScore();
    await loadPreferences();
    _createRewardedAd();
    _createInterstitialAd();
    generateQuestion();  // Assuming this is async
    dataSaved = 0;
    canRevive = true;
    startTotalGameTimer();  // Assuming this is not async
    _canVibrate = await commonFunctions.checkVibrationSupport();
  }

  bool _isPersonalizedAdsOn = true;

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isPersonalizedAdsOn = prefs.getBool('isPersonalizedAdsOn') ?? true;
  }

  //ads related
  AdRequest get request {
    return AdRequest(
      keywords: <String>['foo', 'bar'],
      contentUrl: 'http://foo.com/bar.html',
      nonPersonalizedAds: !_isPersonalizedAdsOn,
    );
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: commonFunctions.getAdUnitId(AdType.rewarded),
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttemptsRewarded) {
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

        // This is where the ad has been closed.
        if (lives > 0) {
          startTimer();
        }
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
        lives += 1; // Award an extra life
        canRevive = false; // Ensure the user can't revive again until they lose again
        //continue the timer
        startTotalGameTimer();
      });
    });
    _rewardedAd = null;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: commonFunctions.getAdUnitId(AdType.interstitial),
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            //_showInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialAd = null;
            _numInterstitialLoadAttempts += 1;
            if (_numInterstitialLoadAttempts <
                maxFailedLoadAttemptsInterstitial) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    var rng = new Random();
    if (rng.nextInt(100) < 20) {
      if (_interstitialAd == null) {
        return;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd(); // Load another ad for next time
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAd(); // Load another ad for next time
      });

      _interstitialAd!.show();
    }
  }

  // game logic and functions
  @override
  void dispose() {
    timer?.cancel();
    _scoreController.dispose();
    totalGameTimer?.cancel();
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void increaseDifficulty() {
    // Increase maxNumber every 5 levels
    if (score <= 10) {
      maxNumber = 4 + score;
    } else if (score <= 30) {
      maxNumber = 25 + score;
    } else if (score <= 50) {
      maxNumber = 80 + score; // For initial scores, increase by 1 unit.
    } else if (score <= 100) {
      maxNumber = 400 +
          2 *
              (score -
                  50); // Increase by 2 units for scores between 50 and 100.
    } else if (score <= 150) {
      maxNumber = 3000 + 5 * (score - 100); // Increase by 5 units beyond 100.
    } else {
      maxNumber =
          10000 + 10 * (score - 150); // Further increase for high scores.
    }

    // Increase gameSpeed every 2 levels
    if (score % 10 == 0) {
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

  String formatDecimal(String value) {
    if (value.contains('.')) {
      return double.parse(value).toStringAsFixed(2);
    }
    return value; // return as-is if no decimal point
  }

  String getReadableTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void generateQuestion() {
    //cancel the old timer if its still running
    timer?.cancel();

    if (lives <= 0) {
      stopTotalGameTimer();
      return;
    }

    var rng = Random();
    int number1, number2;
    String operator;

    number1 = rng.nextInt(maxNumber) + 1;
    number2 = rng.nextInt(maxNumber) + 1;

    List<String> operators = ['+', '-', '×', '÷'];

    switch (widget.gameMode) {
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
        correctAnswer = (number1 /
            number2); // If it's division, take the floor (integer part) of the division
        break;
      case GameMode.Mix: // In case of 'All', pick a random operator
        operator = operators[rng.nextInt(operators.length)];
        correctAnswer = calculateAnswer(operator, number1,
            number2); // Define a function to calculate the answer based on the operator
        break;
    }

    options = generateOptions(correctAnswer); // Generate four options

    setState(() {
      question = '$number1 $operator $number2';
    });

    // After generating a new question, start the timer again
    startTimer();
  }

  dynamic calculateAnswer(String operator, int number1, int number2) {
    switch (operator) {
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

  List<String> generateOptions(dynamic correctAnswer) {
    var rng = Random();
    Set<String> optionsSet = {};
    optionsSet.add(correctAnswer.toString()); // Add correct answer to options

    // Check the format of the correct answer
    int decimalCount = 0;
    if (correctAnswer is double) {
      String correctStr = correctAnswer.toString();
      int dotIndex = correctStr.indexOf('.');
      if (dotIndex != -1) {
        decimalCount = correctStr.substring(dotIndex + 1).length;
      }
    }

    // Capture the least significant digit of the correct answer
    int lastDigitOfCorrectAnswer;
    if (correctAnswer is int) {
      lastDigitOfCorrectAnswer = correctAnswer % 10;
    } else {
      double lastDigitDouble = (correctAnswer * 10) % 10;
      lastDigitOfCorrectAnswer = lastDigitDouble.toInt();
    }

    while (optionsSet.length < 4) {
      dynamic option;

      // Generate a number that ends with the same last digit about 50% of the time
      if (rng.nextBool()) {
        if (decimalCount == 0) {
          option = correctAnswer + rng.nextInt(21) - 10;
          option -= option % 10;
          option += lastDigitOfCorrectAnswer;
        } else if (decimalCount == 1) {
          option =
              (correctAnswer + rng.nextDouble() * 2 - 1).toStringAsFixed(1);
        } else {
          option =
              (correctAnswer + rng.nextDouble() * 2 - 1).toStringAsFixed(2);
        }
      } else {
        if (decimalCount == 0) {
          option = correctAnswer + rng.nextInt(21) - 10;
        } else if (decimalCount == 1) {
          option =
              (correctAnswer + rng.nextDouble() * 2 - 1).toStringAsFixed(1);
        } else {
          option =
              (correctAnswer + rng.nextDouble() * 2 - 1).toStringAsFixed(2);
        }
      }

      optionsSet.add(option.toString());
    }

    // Convert the set to a list and shuffle it to randomize the order of options
    List<String> optionsList = optionsSet.toList();
    optionsList.shuffle();
    return optionsList;
  }

  void checkAnswer(String selectedOption, dynamic correctAnswer) {
    // Cancel the timer regardless of the correctness of the answer
    timer?.cancel();

    if (_canVibrate) {
      if (selectedOption == correctAnswer.toString()) {
        Vibrate.feedback(FeedbackType.success); // Vibrate on correct answer
      } else {
        Vibrate.feedback(FeedbackType.error); // Vibrate on incorrect answer
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
        lives = max(0, lives - 1);
        _backgroundColor = themeColors.errorColor;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _backgroundColor =
              Colors.transparent; // Reset the color after a brief delay
        });
      });

      // If game isn't over, generate a new question
      if (lives > 0) {
        generateQuestion();
      } else {
        stopTotalGameTimer();
      }

      //if game is over save data
      if (lives == 0) {
        _saveGameData();
      }
    }
  }

  //time related
  void updateRemainingTime() {
    switch (widget.gameSpeed) {
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

    const oneSec = Duration(seconds: 1);
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
    if (lives > 1) {
      setState(() {
        lives--;
      });
      generateQuestion();
    } else if (lives == 1) {
      // This condition will handle when lives are exactly 1
      setState(() {
        lives = 0; // Ensure lives are set to 0
      });
      stopTotalGameTimer();
      timer?.cancel();
    } else {
      timer?.cancel();
    }
  }

  void stopTotalGameTimer() {
    totalGameTimer?.cancel();
  }

  void startTotalGameTimer() {
    totalGameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        totalTime = totalTime + Duration(seconds: 1);
      });
    });
  }

  //db functions
  void _saveGameData() async {
    if (_nameController.text.trim().isNotEmpty && dataSaved == 0 && score > 0) {
      // Local data saving logic
      Map<String, dynamic> row = {
        DatabaseHelper.columnName: _nameController.text,
        DatabaseHelper.columnScore: score,
        DatabaseHelper.columnGameMode: widget.gameMode.toString(),
        DatabaseHelper.columnTimeElapsed: getReadableTime(totalTime)
      };
      savedRowId = await DatabaseHelper.instance.insert(row);

      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.none) {
        // No internet connection
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot connect to server')));
        return;
      } else {
        // Firebase data saving logic
        CollectionReference games =
            FirebaseFirestore.instance.collection('endlessModeGameData');
        String? deviceInfo = await commonFunctions.getDeviceInfo();
        String deviceUID = await commonFunctions.getDeviceUUID();

        Map<String, dynamic> firebaseRow = {
          'datetime': DateTime.now().toIso8601String(),
          // Save the current date and time as a string in ISO format
          'deviceInfo': deviceInfo,
          'deviceUID': deviceUID,
          'name': _nameController.text,
          'score': score,
          'gameMode': widget.gameMode.toString(),
          'timeElapsed': getReadableTime(totalTime),
        };

        savedDocument = await games.add(firebaseRow);
      }
      dataSaved = 1;
    }
    else if (_nameController.text.trim().isNotEmpty && dataSaved == 1 && score > 0)
    {
      print('second save');
      print(savedRowId);
      //local db update logic
      if (savedRowId != null) {
        // New data to update
        Map<String, dynamic> updatedRow = {
          DatabaseHelper.columnScore: score,  // The new score
          DatabaseHelper.columnTimeElapsed: getReadableTime(totalTime),  // The new total time
        };

        // Update the row using the saved row ID
        await DatabaseHelper.instance.update(savedRowId!, updatedRow);

      } else {
        print("No row to update"); // Handle this case as needed
      }

      print('saved document:' +savedDocument.toString());
      //firebase update logic
      if (savedDocument != null) {
        // New data to update
        String deviceUID = await commonFunctions.getDeviceUUID();
        Map<String, dynamic> updatedData = {
          'score': score, // The new score
          'timeElapsed': getReadableTime(totalTime),
          'deviceUID': deviceUID,
        };
        print('updated data:' +updatedData.toString());
        // Update the document using the saved DocumentReference
        await savedDocument?.update(updatedData);
        print('done');
      } else {
        print("No document to update"); // Handle this case as needed
      }
    }
    //canRevive = false;
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

  Future<void> _loadHighestScore() async {
    final score = await DatabaseHelper.instance
        .queryHighestScore(widget.gameMode.toString());
    setState(() {
      highestScore = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeColors = ThemeHelper(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        _saveGameData();
        Navigator.pop(context, true);
        return true;
      },
      child: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(children: [
              Container(
                decoration: themeColors.currentTheme.backgroundDecoration(true),
              ),
              Scaffold(
                extendBodyBehindAppBar: true,
                appBar: lives != 0
                    ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: themeColors.iconColor, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                )
                    : null,
                backgroundColor: Colors.transparent,
                body: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  color: _backgroundColor,
                  child: Stack(
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
                                              color: themeColors.textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        // Spacer for a gap between text and progress bar
                                        const SizedBox(height: 30),
                                        // Progress bar
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          // Padding for wider bar
                                          height: 10,
                                          // Height for progress bar
                                          child: TweenAnimationBuilder(
                                            key: key,
                                            tween: Tween(begin: 1.0, end: 0.0),
                                            duration: Duration(seconds: remainingTime),
                                            builder: (context, value, child) {
                                              return LinearProgressIndicator(
                                                value: value,
                                                minHeight: 30,
                                                // Increase height of progress bar
                                                backgroundColor:
                                                themeColors.progressBarBackground,
                                                valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    themeColors.secondaryColor),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                          max(0, lives),
                                              (index) => Icon(Icons.favorite,
                                              color: themeColors.errorColor,
                                              size: 40)).toList(),
                                    ),
                                    const SizedBox(height: 30),
                                    Center(
                                      child: Text(
                                        'Score: $score',
                                        style: GoogleFonts.fredoka(
                                            color: themeColors.textColor, fontSize: 32),
                                      ),
                                    ),
                                    // Animated score pop-up
                                    FadeTransition(
                                      opacity: _scoreAnimation,
                                      child: Text(
                                        '+1',
                                        style: GoogleFonts.fredoka(
                                            color: themeColors.positiveColor,
                                            fontSize: 32),
                                      ),
                                    ),

                                    SizedBox(height: 30),
                                    Container(
                                      child: Text(
                                        question.contains('÷')
                                            ? formatDecimal(question)
                                            : question,
                                        // check if division is present in the question
                                        style: GoogleFonts.fredoka(
                                            fontSize: 60, color: themeColors.textColor),
                                      ),
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
                                        AnimatedButton(formatDecimal(options[0]),
                                            onPressed: () =>
                                                checkAnswer(options[0], correctAnswer)),
                                        AnimatedButton(formatDecimal(options[1]),
                                            onPressed: () =>
                                                checkAnswer(options[1], correctAnswer)),
                                        AnimatedButton(formatDecimal(options[2]),
                                            onPressed: () =>
                                                checkAnswer(options[2], correctAnswer)),
                                        AnimatedButton(formatDecimal(options[3]),
                                            onPressed: () =>
                                                checkAnswer(options[3], correctAnswer)),
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
                            color: themeColors.backdropBackgroundColor.withOpacity(0.4),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                0.6, // 80% of screen width
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5.0, // This gives shadow to the card
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text('Game Over',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.fredoka(
                                              color: themeColors.errorColor,
                                              fontSize: 32)),
                                      SizedBox(height: 20),
                                      Text(
                                        'Your Name',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.0),
                                          border: Border.all(
                                              color: themeColors.primaryColor,
                                              width: 2.0),
                                          color: _nameController.text.isEmpty
                                              ? themeColors.errorColor
                                              : themeColors
                                              .tableSurroundColor, // Check here
                                        ),
                                        child: TextField(
                                          controller: _nameController,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: themeColors.textColor),
                                          decoration: InputDecoration(
                                            hintText: 'Name',
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            counterText: '',
                                          ),
                                          maxLength: 12,
                                          onChanged: (value) {
                                            _savePlayerName(value);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text('Your Score: $score',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.fredoka(
                                              color: themeColors.textColor,
                                              fontSize: 24)),
                                      SizedBox(height: 20),
                                      Text('Best Score: $highestScore',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.fredoka(
                                              color: themeColors.textColor,
                                              fontSize: 24)),
                                      SizedBox(height: 30),
                                      if (canRevive == true &&
                                          _rewardedAd != null &&
                                          dataSaved == 0) ...[
                                        Material(
                                          elevation: 5.0,
                                          borderRadius: BorderRadius.circular(30),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  themeColors.positiveColorLight,
                                                  themeColors.positiveColorDark,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                _showRewardedAd();
                                              },
                                              borderRadius: BorderRadius.circular(30),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.play_arrow,
                                                        color: themeColors.btnTextColor,
                                                        size: 24),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Revive',
                                                      style: GoogleFonts.fredoka(
                                                        color: themeColors.btnTextColor,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                      AnimatedButton(
                                        'Retry',
                                        onPressed: () {
                                          _showInterstitialAd();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => GameScreen(
                                                gameMode: widget.gameMode,
                                                gameSpeed: GameSpeed.fifteen,
                                              ),
                                            ),
                                          ).then((_) {
                                            setState(() {});
                                          });
                                        },
                                        verticalPadding: 10.0,
                                      ),
                                      AnimatedButton(
                                        'Wall of Fame',
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  WallOfFameScreen(
                                                    gameMode: widget.gameMode,
                                                  )))
                                              .then((_) {
                                            setState(() {});
                                          });
                                        },
                                        verticalPadding: 10.0,
                                      ),
                                      AnimatedButton(
                                        'Back',
                                        onPressed: () {
                                          _showInterstitialAd();
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  EndlessModeScreen()))
                                              .then((_) {
                                            setState(() {});
                                          });
                                        },
                                        verticalPadding: 10.0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ]);// Your actual widget here
          }
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));  // Replace with your loading screen
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));  // Replace with your loading screen
        },
      ),
    );
  }
}
