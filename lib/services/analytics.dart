import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsService {
  getInstance();
  trackEvent(String eventName);
  trackScreenView(String pageName);
}

class AnalyticsServiceApp extends AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  FirebaseAnalytics getInstance() {
    return _analytics;
  }

  @override
  void trackEvent(String eventName) {
    _analytics.logEvent(
      name: eventName,
      parameters: {},
    );
  }

  @override
  void trackScreenView(String pageName) {
    _analytics.logScreenView(screenName: pageName);
  }
}
