import 'package:dars_67/controllers/users_controller.dart';
import 'package:dars_67/services/firebaseauth.dart';
import 'package:dars_67/utils/current_user.dart';
import 'package:dars_67/views/screens/quiz_screen.dart';
import 'package:dars_67/views/screens/reset_password_screen.dart';

import 'register_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  bool isLoading = false;

  String? email;
  String? password;

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        await firebaseAuthServices.signIn(email!, password!);

   
    CurrentUser.email=email!;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return QuizScreen();
            },
          ),
        );
      } on Exception catch (e) {
        String message = e.toString();
        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email mavjud";
        }
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title:  Text("Xatolik"),
              content: Text(message),
            );
          },
        );
      } 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Kirish"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding:  EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 FlutterLogo(
                  size: 90,
                ),
                 SizedBox(height: 30),
                TextFormField(
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Elektron pochta",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Iltimos elektron pochtangizni kiriting";
                    }
        
                    return null;
                  },
                  onSaved: (newValue) {
                    //? save email
                    email = newValue;
                  },
                ),
                 SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Parol",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Iltimos parolingizni kiriting";
                    }
        
                    return null;
                  },
                  onSaved: (newValue) {
                    //? save password
                    password = newValue;
                  },
                ),
                               SizedBox(height: 20),
                isLoading
                    ?  Center(
                        child: CircularProgressIndicator(),
                      )
                    : FilledButton(
                        onPressed: submit,
                        child:  Text("KIRISH"),
                      ),
                 SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) {
                          return  RegisterScreen();
                        },
                      ),
                    );
                  },
                  child:  Text("Ro'yxatdan O'tish"),
                ),
                SizedBox(),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ResetPasswordScreen()));
                    },
                    child: Text(
                      "Reset password",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent,
                          fontSize: 18),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
