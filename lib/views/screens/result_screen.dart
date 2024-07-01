import 'package:dars_67/controllers/users_controller.dart';
import 'package:dars_67/models/user.dart' as user1;
import 'package:dars_67/views/screens/login_screen.dart';
import 'package:dars_67/views/screens/quiz_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class FinalScreen extends StatefulWidget {
  int correctAnsver;
  FinalScreen({super.key, required this.correctAnsver});

  @override
  State<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  Future<void> _updateUserScore() async {
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        final currentUserData = docSnapshot.data() as Map<String, dynamic>;
        final previousCorrectAnswer = currentUserData['correctAnswers'] as int;
        final updatedCorrectAnswer =
            previousCorrectAnswer + widget.correctAnsver;

        await userDoc.update({'correctAnswers': updatedCorrectAnswer});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _updateUserScore();
  }

  @override
  Widget build(BuildContext context) {
     UsersController userController = context.watch<UsersController>();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return LoginScreen();
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 10)
                ],
              ),
              backgroundColor: Colors.purple,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your Correct Answer: ${widget.correctAnsver}",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Restart",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: userController.getUsers(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final users = snapshot.data!.docs;
                          users.sort((a, b) => b['correctAnswers']
                              .compareTo(a['correctAnswers']));
                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = user1.User.fromJson(users[index]);
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.red,
                                ),
                                title: Text(
                                  "User: ${user.userEmail}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Correct answer: ${user.correctAnswers}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
