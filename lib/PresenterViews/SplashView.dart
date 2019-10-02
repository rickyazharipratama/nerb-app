import 'package:flutter/cupertino.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Views/Pages/LandingPage.dart';
import 'package:nerb/Views/Pages/NoLocationServices.dart';
import 'package:nerb/Views/Pages/WrapperPermission.dart';

class SplashView{

  bool _isNeedLoading = false;

  bool get isNeedLoading => _isNeedLoading;
  set setNeedLoading(bool val){
    _isNeedLoading = val;
  }

  goToLandingPage(){
    NerbNavigator.instance.newClearRoute(currentContext(), child: LandingPage());
  }

  goToWrapperPermission(){
    NerbNavigator.instance.newClearRoute(currentContext(), child: WrapperPermission());
  }

  goToNoLocationServie(){
    NerbNavigator.instance.newClearRoute(currentContext(), child: NoLocationServices());
  }

  BuildContext currentContext(){
    return null;
  }

}