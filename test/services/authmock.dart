import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';

class AuthServiceMock extends AuthService {
  UserDT? _mockUser;

  @override
  UserDT? getCurrentUser() {
    return _mockUser;
  }

  @override
  String? getCurrentUserUid() {
    if (_mockUser != null) {
      return _mockUser!.uid;
    } else {
      return null;
    }
  }

  @override
  Stream<UserDT?> streamUserState() {
    return Stream.periodic(Duration.zero, (_) => getCurrentUser());
  }

  @override
  Future<void> signUp(String email, String password) async {
    await Future.delayed(Duration.zero);
    _mockUser = UserDT(
      uid: "123",
      email: "mock@test.com",
      emailVerified: false,
    );
  }

  @override
  Future<void> signIn(String email, String password) async {
    await Future.delayed(Duration.zero);
    _mockUser = UserDT(
      uid: "123",
      email: "mock@test.com",
      emailVerified: true,
    );
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(Duration.zero);
    _mockUser = null;
  }

  @override
  Future<void> resetPassword(String email) async {
    await Future.delayed(Duration.zero);
  }

  @override
  Future<void> sendEmailVerification() async {
    await Future.delayed(const Duration(seconds: 5));
    _mockUser = UserDT(
      uid: "123",
      email: "mock@test.com",
      emailVerified: true,
    );
    ;
  }
}
