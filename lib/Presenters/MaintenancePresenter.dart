import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/rendering.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/PresenterViews/MaintenanceView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class MaintenancePresenter extends BasePresenter{

  Timer _timer;
  RemoteConfig _remoteConfig;
  MaintenanceView _view;

  MaintenanceView get view => _view;
  Timer get timer => _timer;
  RemoteConfig get remoteConfig => _remoteConfig;

  set setView(MaintenanceView vw){
    _view = vw;
  }

  setTimer({int minutes}){
    _timer = Timer.periodic(Duration(minutes: minutes),(time) async{
      await setRemoteConfig();
      bool isMaintenance  = remoteConfig.getBool(ConstantCollections.REMOTE_CONFIG_IS_MAINTENANCE);
      debugPrint("is running");
      if(!isMaintenance){
        debugPrint("go to splash");
        view.alreadyDoneMaintenance();
      }
    });
    CommonHelper.instance.settingSystemUi();
  }

  setRemoteConfig() async{
    _remoteConfig = await CommonHelper.instance.fetchRemoteConfig();
  }

  @override
  void initiateData() {
    super.initiateData();
    FirebaseAnalyticHelper.instance.setScreen(
      screen: "Maintenance"
    );
    setTimer(minutes: 3);
  }
}