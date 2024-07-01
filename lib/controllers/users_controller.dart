import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars_67/utils/current_user.dart';
import 'package:flutter/material.dart';

class UsersController extends ChangeNotifier {
  final userCollection = FirebaseFirestore.instance.collection("users");

  Stream<QuerySnapshot> getUserLeaderboard() async* {
    yield* userCollection.snapshots();
  }

  void addUser(String userEmail, int correctAnswers) {
    userCollection.doc(userEmail).set({
      "userEmail": userEmail,
      "correctAnswers": correctAnswers,
    });
  }

  Stream<QuerySnapshot> getUsers() {
    return getUserLeaderboard();
  }

  void addAnswer(String email, int correctAnswers) {
    print(email);
    print(correctAnswers);
    userCollection.doc(email).update({
      "userEmail": email,
      'correctAnswers': correctAnswers,
    });
  }
}
