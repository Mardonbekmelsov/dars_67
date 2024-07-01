import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  String id;
  String question;
  List options;
  num correctIndex;

  Quiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory Quiz.fromJson(QueryDocumentSnapshot query) {
    return Quiz(
      id: query.id,
      question: query['question'],
      options: query['options'],
      correctIndex: query['correctIndex'],
    );
  }

  toJson() {}
}
