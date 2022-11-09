import 'package:firebase_auth/firebase_auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';

//  Contains all methods and data pertaining to user authentication
class AuthService {
  // Instantiate FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user info if logged in - returned null if not
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Stream that listens for authentication changes
  Stream<User?> user() {
    return _auth.authStateChanges();
  }

  // Method for signing up
  // Should be caught with try/catch for error handling
  Future<void> signUp(String email, String password) async {
    // Obtain User object (FireAuth function)
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    // Store in database
    User? user = result.user;
    await DatabaseService(uid: user!.uid).createUser();
  }

  // Method for singing in
  // Should be caught with try/catch for error handling
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Method for signing out
  // Should be caught with try/catch for error handling
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Method for sending password reset email
  // Should be caught with try/catch for error handling
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
