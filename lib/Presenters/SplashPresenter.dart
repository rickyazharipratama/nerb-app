import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/PresenterViews/SplashView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class SplashPresenter extends BasePresenter{

  SplashView _view;
  RemoteConfig _remoteConfig;
  bool _isError = false;
  

  SplashView get view => _view;
  set setView(SplashView vw){
    _view = vw;
  }

  bool get isError => _isError;
  set isError(bool val){
     _isError = isError;
  }

  RemoteConfig get remoteConfig => _remoteConfig;

  @override
  void initiateData()async{
    super.initiateData();
    FirebaseAnalyticHelper.instance.setScreen(
      screen: "splash"
    );
    if(!(await isMaintenance(view.currentContext()))){
      if(!(await isMajorUpdate(view.currentContext()))){
        openLastAct();
      }
    }
  }

  openLastAct() async{
    if(await LocationPermissions().checkServiceStatus() == ServiceStatus.enabled){
      if(await LocationPermissions().checkPermissionStatus() == PermissionStatus.granted){
        view.goToLandingPage();
      }else{
        view.goToWrapperPermission();
      }
    }else{
      view.goToNoLocationServie();
    }
  }
}