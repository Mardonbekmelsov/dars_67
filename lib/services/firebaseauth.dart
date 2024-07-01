import 'package:dars_67/controllers/users_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  Future<void> signIn(String newEmail, String newPassword) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: newEmail, password: newPassword);
  }

  Future<void> signUp(String newEmail, String newPassword) async {
    final UsersController usersController=UsersController();
    usersController.addUser(newEmail,  0);

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: newEmail, password: newPassword);

  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
