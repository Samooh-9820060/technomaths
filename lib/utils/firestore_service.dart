import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technomaths/utils/commonFunctions.dart';

import '../config/game_mode.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, Map<String, int>>> fetchPlayerHighestScores() async {
    String deviceUUID = await commonFunctions.getDeviceUUID();

    Map<String, Map<String, int>> results = {};

    for (GameMode mode in GameMode.values) {
      QuerySnapshot queryResult = await _firestore
          .collection('endlessModeGameData')
          .where('deviceUID', isEqualTo: deviceUUID)
          .where('gameMode', isEqualTo: mode.toString()) // Filter by the gameMode field
          .orderBy('score', descending: true)
          .limit(1)
          .get();

      if (!queryResult.docs.isEmpty) {
        Map<String, dynamic>? data = queryResult.docs.first.data() as Map<String, dynamic>?;
        int score = data?['score'] ?? 0;
        int timeElapsedInSeconds = commonFunctions.convertTimeStringToSeconds(data?['timeElapsed']); // Assuming you have a function to do this

        if (score > 0) {
          int rank = await getRankForScore(score, timeElapsedInSeconds, mode); // Note: we pass the game mode as a parameter now
          results[mode.toString()] = {
            'score': score,
            'rank': rank
          };
        }
      }
    }

    return results;
  }

  Future<int> getRankForScore(int score, int timeElapsedInSeconds, GameMode selectedMode) async {
    // First count all the scores higher than the given score
    AggregateQuerySnapshot scoresHigherThanGiven = await FirebaseFirestore.instance
        .collection('endlessModeGameData')
        .where('gameMode', isEqualTo: selectedMode.toString())
        .where('score', isGreaterThan: score)
        .count()
        .get();

    // Now, for the scores that are equal to the given score, count the ones with less time elapsed (i.e. faster completion times)
    AggregateQuerySnapshot scoresEqualButFaster = await FirebaseFirestore.instance
        .collection('endlessModeGameData')
        .where('gameMode', isEqualTo: selectedMode.toString())
        .where('score', isEqualTo: score)
        .where('timeElapsed', isLessThanOrEqualTo: commonFunctions.convertSecondsToTimeString(timeElapsedInSeconds))
        .count()
        .get();

    // Subtract the number of scores that are exactly equal to the given timeElapsed
    AggregateQuerySnapshot scoresExactlyEqualTime = await FirebaseFirestore.instance
        .collection('endlessModeGameData')
        .where('gameMode', isEqualTo: selectedMode.toString())
        .where('score', isEqualTo: score)
        .where('timeElapsed', isEqualTo: commonFunctions.convertSecondsToTimeString(timeElapsedInSeconds))
        .count()
        .get();

    // The rank will be the sum of scoresHigherThanGiven and scoresEqualButFaster minus scoresExactlyEqualTime plus one (1-based ranking)
    int rank = scoresHigherThanGiven.count + scoresEqualButFaster.count - scoresExactlyEqualTime.count + 1;

    return rank;
  }

  static Future<Map<String, String>> generateMessage(String gameMode, String score, String rank) async {
    // Fetch player's name from Shared Preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String playerName = prefs.getString('playerName') ?? 'Player';

    int scoreInt = int.parse(score);
    int rankInt = int.parse(rank);

    gameMode = gameMode.replaceAll("GameMode.", "");
    // Get the count of notification messages
    AggregateQuerySnapshot countSnapshot = await FirebaseFirestore.instance
        .collection('notificationMessages')
        .count()
        .get();
    int totalCount = countSnapshot.count;

    // If no messages are found, return a default message
    if (totalCount == 0) {
      return {
        "message": "Hello $playerName! Play more and improve your rank in $gameMode.",
        "documentId": "" // No document ID in this case
      };    }

    // Get a random skip value
    Random rand = Random();
    int number = rand.nextInt(totalCount);

    // Fetch a random message from Firestore's notificationMessages collection
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('notificationMessages')
        .where('index', isEqualTo: number)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return {
        "message": "Hello $playerName! Play more and improve your rank in $gameMode.",
        "documentId": "" // No document ID in this case
      };
    }


    String selectedMessage = snapshot.docs.first.get('message') as String;
    String documentId = snapshot.docs.first.id;

    selectedMessage = selectedMessage
        .replaceAll("{playerName}", playerName)
        .replaceAll("{gameMode}", gameMode)
        .replaceAll("{score}", score)
        .replaceAll("{rank}", rank);

    selectedMessage = commonFunctions.processDynamicParts(selectedMessage, scoreInt, rankInt);

    return {
      "message": selectedMessage,
      "documentId": documentId
    };
  }

  Future<void> updateClickCount(String documentId) async {
    final docRef = FirebaseFirestore.instance.collection('notificationMessages').doc(documentId);

    await docRef.update({
      'clickCount': FieldValue.increment(1)
    });
  }

}
