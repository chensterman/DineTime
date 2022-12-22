import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalytics getInstance(){
    return _analytics;
  }
  void trackEvent(String eventName){
    _analytics.logEvent(name: eventName, parameters: {},);
  }
  void trackScreenView(String pageName){
    _analytics.logScreenView(screenName: pageName);
  }
}