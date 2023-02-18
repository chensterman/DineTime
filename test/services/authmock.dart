import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';

class AuthServiceMock extends AuthService {
  @override
  UserDT? getCurrentUser() {
    return UserDT(
      uid: "Mock User ID",
      email: "mock@test.com",
      emailVerified: false,
    );
  }

  @override
  String? getCurrentUserUid() {
    return "Mock User ID";
  }

  @override
  Stream<UserDT?> streamUserState() async* {
    yield getCurrentUser();
  }

  @override
  Future<void> signUp(String email, String password) async {
    await Future.delayed(Duration.zero);
  }

  @override
  Future<void> signIn(String email, String password) async {
    await Future.delayed(Duration.zero);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(Duration.zero);
  }

  @override
  Future<void> resetPassword(String email) async {
    await Future.delayed(Duration.zero);
  }

  @override
  Future<void> sendEmailVerification() async {
    await Future.delayed(Duration.zero);
  }
}
