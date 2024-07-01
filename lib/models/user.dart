import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String userEmail;
  String id;
  int correctAnswers;

  User({required this.userEmail, required this.id, required this.correctAnswers});

  factory User.fromJson(QueryDocumentSnapshot json){
    return User(userEmail: json['userEmail'], id: json.id, correctAnswers: json['correctAnswers']);
  }

}