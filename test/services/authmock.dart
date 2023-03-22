import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';

class AuthServiceMock extends AuthService {
  UserDT? _mockUser;

  @override
  Future<UserDT?> getCurrentUser() async {
    await Future.delayed(Duration.zero);
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
  String? getCurrentUserEmail() {
    return "test@mock.com";
  }

  @override
  Stream<UserDT?> streamUserState() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (_) {
      return getCurrentUser();
    }).asyncMap((event) async => await event);
  }

  @override
  Future<void> signUp(String email, String password) async {
    await Future.delayed(Duration.zero);
    _mockUser = UserDT(
      uid: "123",
      email: "mock@test.com",
      emailVerified: false,
      isCustomer: true,
    );
  }

  @override
  Future<void> signIn(String email, String password) async {
    await Future.delayed(Duration.zero);
    _mockUser = UserDT(
      uid: "123",
      email: "mock@test.com",
      emailVerified: true,
      isCustomer: true,
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
      isCustomer: true,
    );
    ;
  }

  @override
  Future<void> deleteAccount() async {
    await Future.delayed(Duration.zero);
    _mockUser = null;
  }
}
