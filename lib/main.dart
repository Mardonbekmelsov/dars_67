import 'package:dars_67/controllers/quiz_controller.dart';
import 'package:dars_67/controllers/users_controller.dart';
import 'package:dars_67/views/screens/quiz_screen.dart';
import 'package:provider/provider.dart';

import 'views/screens/firebase_options.dart';
import 'views/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              return QuizController();
            },
          ),
          ChangeNotifierProvider(create: (context) {
            return UsersController();
          })
        ],
        builder: (context, child) {
          return MaterialApp(
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoginScreen();
                  }
                  return QuizScreen();
                }),
          );
        });
  }
}
