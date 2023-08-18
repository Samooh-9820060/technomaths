import 'package:cloud_firestore/cloud_firestore.dart';

class devUseMethods {
  //add bulk messages to the list
  static Future<void> addMessagesInBulk() async {
    final List<String> messages = [
      //"Hey {playerName}! In {gameMode}, you're ranked {rank}. Think you can top that score of {score}?",
      //"Guess what {playerName}? You're ruling the {gameMode} charts! Sitting pretty at rank {rank} with a whopping score of {score}. 🌟",
      //"{playerName}, you're a natural! {gameMode} rank {rank} and {score} points? That's impressive. 👏",
      //"{playerName}, with a rank of {rank} in {gameMode}, you're blazing through! Aim for rank {rank-1}. I bet you can! 🔥",
      //"News flash, {playerName}! You're making waves in {gameMode}. Scored {score} and clinched rank {rank}. Keep soaring! 🚀",
      //"Look at you go, {playerName}! You're in the {gameMode} elite, holding rank {rank} with {score} points. Encore! 🎉",
      //"Step aside, everyone! {playerName} is climbing the {gameMode} leaderboard. Rank {rank} and counting. Onwards and upwards! 🥳",
      //"Hold the front page! {playerName} just smashed their way to rank {rank} in {gameMode}. And that score of {score}? Mind-blowing! 🎈",
      //"A round of applause for {playerName}! Dominating {gameMode} with a rank of {rank} and a score of {score}. Take a bow! 👑",
      //"Heads up, world! {playerName} is on a {gameMode} roll. Rank {rank} and a score of {score}? Unstoppable! 🌊",
    ];

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final WriteBatch batch = firestore.batch();

    final CollectionReference messagesCollection = firestore.collection('notificationMessages');

    int startIndex = 2; // starting index

    for (final message in messages) {
      final DocumentReference docRef = messagesCollection.doc(); // auto-generate document ID
      batch.set(docRef, {
        'message': message,
        'index': startIndex,
        'clickCount': 0,
      });
      startIndex++;
    }

    await batch.commit();
  }
}