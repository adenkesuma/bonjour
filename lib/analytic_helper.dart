import 'package:firebase_analytics/firebase_analytics.dart';


class MyAnalyticsHelper {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Future<void> testEventLog (_value,info) async {
  //   await analytics.logEvent(name: 'tombol_${info}_${_value}');
  //   print('Send Event : tombol_${info}_${_value}');
  // }
}