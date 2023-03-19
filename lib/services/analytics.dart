import 'package:firebase_analytics/firebase_analytics.dart';

import 'services.dart';

class AnalyticsServiceApp extends AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  void trackEvent(String eventName) {
    _analytics.logEvent(
      name: eventName,
      parameters: {},
    );
  }

  void trackEventNum(String eventName, double value) {
    _analytics.logEvent(
      name: eventName,
      parameters: {
        "value": value,
      },
    );
  }

  @override
  void trackScreenView(String pageName, String screenClass) {
    _analytics.logScreenView(screenName: pageName, screenClass: screenClass);
  }
}
