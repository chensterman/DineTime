import 'package:firebase_auth/firebase_auth.dart';

// Authentication class:
//  Contains all methods and data pertaining to user authentication.
class AuthService {
  // Instantiate FirebaseAuth.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Stream that listens for authentication changes.
  Stream<User?> user() {
    return _auth.authStateChanges();
  }

  // Method for signing up.
  Future<int> signUp(String email, String password) async {
    try {
      // Obtain User object (FireAuth function).
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Store in database.

      // Return 0 on success.
      return 0;
    } catch (e) {
      print(e);
      // Return 1 on error.
      return 1;
    }
  }

  // Method for singing in (returns status as int).
  Future<int> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Return 0 on success.
      return 0;
    } catch (error) {
      // Return 1 on error.
      return 1;
    }
  }

  // Method for signing out.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Method for sending password reset email.
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
