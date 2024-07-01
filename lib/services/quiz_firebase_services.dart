import 'package:cloud_firestore/cloud_firestore.dart';

class QuizFirebaseServices{
  final quizCollection=FirebaseFirestore.instance.collection('quizes');

  Stream<QuerySnapshot> getQuizes() async* {
    yield* quizCollection.snapshots();
  }
  void addQuiz(String question, String option1, String option2, String option3, int correctIndex){
    quizCollection.add({
      "question":question,
      "options": [option1,option2, option3],
      "correctIndex": correctIndex
    });
  }
  void editQuiz(String id,String question, String option1, String option2, String option3, int correctIndex){
    quizCollection.doc(id).update({
      "question":question,
      "options": [option1,option2, option3],
      "correctIndex": correctIndex,
    });
  }
}