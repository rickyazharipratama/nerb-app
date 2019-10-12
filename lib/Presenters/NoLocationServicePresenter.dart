import 'dart:async';

import 'package:location_permissions/location_permissions.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/PresenterViews/NoLocationServiceView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class NoLocationServicePresenter extends BasePresenter{
  Timer timer;
  NoLocationServiceView _view;

  NoLocationServiceView get view => _view;
  set setView(NoLocationServiceView vw){
    _view = vw;
  }

  @override
  void initiateData() {
    super.initiateData();
    FirebaseAnalyticHelper.instance.setScreen(
      screen: "No Location Services"
    );
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async{
       CommonHelper.instance.showLog("location service");
       if(await LocationPermissions().checkServiceStatus() == ServiceStatus.enabled){
         if(await LocationPermissions().checkPermissionStatus() == PermissionStatus.granted){
           view.goToLandingPage();
         }else{
           view.goToWrapperPermission();
         }
       }
      }
    );
  }
}