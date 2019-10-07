import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class FirebaseAnalyticHelper{

  static FirebaseAnalyticHelper instance = FirebaseAnalyticHelper();

  FirebaseAnalytics _anal;

  FirebaseAnalyticHelper(){
    _anal = FirebaseAnalytics();
  }

  Future<void> sendEvent({
    @required String event,
    @required Map<String,dynamic> params
  }) async{
    await _anal.logEvent(
      name: event,
      parameters: params
    );
  }

  Future<void> setScreen({
    @required String screen
  }) async{
    await _anal.setCurrentScreen(
      screenName: screen
    );
  }
}