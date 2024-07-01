import 'package:dars_67/controllers/quiz_controller.dart';
import 'package:dars_67/models/quiz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
   QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final questionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final correctIndexController = TextEditingController();
  PageController pageController = PageController();
  int correct = 0;

  @override
  void dispose() {
    questionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    correctIndexController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = context.watch<QuizController>();
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title:  Text("Quiz"),
      ),
      body: StreamBuilder(
        stream: quizController.getQuizes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null) {
            return  Center(
              child: Text("quizlar topilmadi"),
            );
          }

          final quizes = snapshot.data!.docs;

          return quizes.isEmpty
              ?  Center(
                  child: Text("quizlar yo'q"),
                )
              : PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: pageController,
                  physics:
                       NeverScrollableScrollPhysics(), // Orqaga qaytarilmasin
                  itemCount: quizes.length,
                  itemBuilder: (context, index) {
                    final quiz = Quiz.fromJson(quizes[index]);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onLongPress: () {
                            questionController.text = quiz.question;
                            option1Controller.text = quiz.options[0];
                            option2Controller.text = quiz.options[1];
                            option3Controller.text = quiz.options[2];
                            correctIndexController.text =
                                quiz.correctIndex.toString();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:  Text("Edit quiz"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: questionController,
                                            decoration:  InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Enter question"),
                                          ),
                                           SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller: option1Controller,
                                            decoration:  InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Enter 1 st option"),
                                          ),
                                           SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller: option2Controller,
                                            decoration:  InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Enter 2 nd option"),
                                          ),
                                           SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller: option3Controller,
                                            decoration:  InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Enter 3 rd option"),
                                          ),
                                           SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller: correctIndexController,
                                            decoration:  InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText:
                                                    "Enter correct index"),
                                          ),
                                           SizedBox(
                                            height: 15,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              quizController.editQuiz(
                                                  quiz.id,
                                                  questionController.text,
                                                  option1Controller.text,
                                                  option2Controller.text,
                                                  option3Controller.text,
                                                  int.parse(
                                                      correctIndexController
                                                          .text));
                                              Navigator.pop(context);
                                              questionController.clear();
                                              option1Controller.clear();
                                              option2Controller.clear();
                                              option3Controller.clear();
                                              correctIndexController.clear();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child:  Text("Edit"),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            quiz.question,
                            style:  TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                         SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (var i = 0; i < quiz.options.length; i++)
                              ElevatedButton(
                                  onPressed: () {
                                    if (i == quiz.correctIndex.toInt()) {
                                      correct += 1;
                                    }
                                    if (index != quizes.length - 1) {
                                      pageController.nextPage(
                                        duration:
                                             Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FinalScreen(
                                                correctAnsver: correct),
                                          ));
                                    }
                                  },
                                  child: Text(
                                    quiz.options[i],
                                    style:  TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  )),
                          ],
                        )
                      ],
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title:  Text("Add Quiz"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: questionController,
                        decoration:  InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter question"),
                      ),
                       SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: option1Controller,
                        decoration:  InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter 1 st option"),
                      ),
                       SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: option2Controller,
                        decoration:  InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter 2 nd option"),
                      ),
                       SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: option3Controller,
                        decoration:  InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter 3 rd option"),
                      ),
                       SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: correctIndexController,
                        decoration:  InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter correct index"),
                      ),
                       SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          quizController.addQuiz(
                              questionController.text,
                              option1Controller.text,
                              option2Controller.text,
                              option3Controller.text,
                              int.parse(correctIndexController.text));
                          Navigator.pop(context);
                          questionController.clear();
                          option1Controller.clear();
                          option2Controller.clear();
                          option3Controller.clear();
                          correctIndexController.clear();
                        },
                        child:  Text("Add"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child:  Icon(
          Icons.add,
        ),
      ),
    );
  }
}
