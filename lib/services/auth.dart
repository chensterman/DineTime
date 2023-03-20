import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';

import 'services.dart';

//  Contains all methods and data pertaining to user authentication
class AuthServiceApp extends AuthService {
  // Instantiate FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user info if logged in - returned null if not
  @override
  Future<UserDT?> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      return null;
    } else {
      firebaseUser.reload();
      bool isCustomer =
          await DatabaseServiceApp().isCustomerUser(firebaseUser.uid);
      return UserDT(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        emailVerified: firebaseUser.emailVerified,
        isCustomer: isCustomer,
      );
    }
  }

  @override
  String? getCurrentUserUid() {
    return _auth.currentUser?.uid;
  }

  // Stream that listens for authentication changes
  @override
  Stream<UserDT?> streamUserState() async* {
    Stream<User?> firebaseUserStream = _auth.authStateChanges();
    await for (User? firebaseUser in firebaseUserStream) {
      if (firebaseUser == null) {
        yield null;
      } else {
        bool isCustomer =
            await DatabaseServiceApp().isCustomerUser(firebaseUser.uid);
        UserDT user = UserDT(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          emailVerified: firebaseUser.emailVerified,
          isCustomer: isCustomer,
        );
        yield user;
      }
    }
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
    await DatabaseServiceApp().customerCreate(user!.uid);
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

  @override
  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  @override
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }
}
