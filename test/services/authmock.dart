import 'package:dinetime_mobile_mvp/services/auth.dart';

class AuthServiceMock extends AuthService {
  @override
  String? getCurrentUserUid() {
    return "Mock User ID";
  }
}
