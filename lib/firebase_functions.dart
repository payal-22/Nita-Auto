import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFunctions {
  // Instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up with email and password
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error in Sign Up: $e");
      return null;
    }
  }

  // Sign In with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error in Sign In: $e");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error in Sign Out: $e");
    }
  }

  // Get current user
  User? getCurrentUser() {
    try {
      return _auth.currentUser;
    } catch (e) {
      print("Error in getting current user: $e");
      return null;
    }
  }
}
