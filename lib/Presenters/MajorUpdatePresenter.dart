import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Models/Response/AppVersion.dart';
import 'package:nerb/PresenterViews/MajorUpdateView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class MajorUpdatePresenter extends BasePresenter{
  RemoteConfig _rc;
  AppVersion _version;
  MajorUpdateView _view;
  

  RemoteConfig get rc => _rc;
  AppVersion get version => _version;
  MajorUpdateView get view => _view;

  set setView(MajorUpdateView vw){
    _view = vw;
  }


  @override
  void initiateData()async{
    super.initiateData();
    _rc = await CommonHelper.instance.fetchRemoteConfig();
    String tmp = rc.getString(ConstantCollections.REMOTE_CONFIG_UPDATE_VERSION);
    _version = AppVersion.fromJson(jsonDecode(tmp));
  }
}