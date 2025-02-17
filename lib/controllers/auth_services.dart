import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static Future<String> createAccountWithEmail(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  //  login  with email password method

  static Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // log out user

  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  //  check whether the user is sign in or not

  static Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return Future.value(user != null);
  }
}
