import 'package:firebase_auth/firebase_auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';

abstract class AuthService {
  getCurrentUser();
  getCurrentUserUid();
  Stream<User?> streamUserState();
  signUp(String email, String password);
  signIn(String email, String password);
  signOut();
  resetPassword(String email);
}

//  Contains all methods and data pertaining to user authentication
class AuthServiceApp extends AuthService {
  // Instantiate FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user info if logged in - returned null if not
  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  @override
  String? getCurrentUserUid() {
    return _auth.currentUser?.uid;
  }

  // Stream that listens for authentication changes
  @override
  Stream<User?> streamUserState() {
    return _auth.authStateChanges();
  }

  // Method for signing up
  // Should be caught with try/catch for error handling
  @override
  Future<void> signUp(String email, String password) async {
    // Obtain User object (FireAuth function)
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    // Store in database
    User? user = result.user;
    await DatabaseServiceApp().createCustomer(user!.uid);
  }

  // Method for singing in
  // Should be caught with try/catch for error handling
  @override
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Method for signing out
  // Should be caught with try/catch for error handling
  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Method for sending password reset email
  // Should be caught with try/catch for error handling
  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
