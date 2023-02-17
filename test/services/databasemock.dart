import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';

class DatabaseServiceMock extends DatabaseService {
  @override
  Stream<DocumentSnapshot<Object?>> customerStream(String customerId) {
    return super.customerStream(customerId);
  }

  @override
  Future<String?> customerLocationAddress(String customerId) async {
    await Future.delayed(Duration.zero);
    return "City, State Zipcode";
  }

  @override
  Future<void> updateCustomer(
      String customerId, Map<String, dynamic> customerData) async {
    await await Future.delayed(Duration.zero);
  }
}
