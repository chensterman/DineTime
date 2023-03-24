import 'package:dinetime_mobile_mvp/services/services.dart';

class AnalyticsServiceMock extends AnalyticsService {
  @override
  void trackEvent(String eventName) {
    print("eventName: " + eventName);
  }

  @override
  void trackScreenView(String pageName, String className) {
    print("page view:" + pageName + "class: " + className);
  }

  @override
  void trackEventNum(String eventName, double value) {
    print("eventName:" + eventName + "value: " + value.toString());
  }
}
