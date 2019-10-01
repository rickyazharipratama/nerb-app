import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Views/Pages/LandingPage.dart';
import 'package:nerb/Views/Pages/WrapperPermission.dart';

class NoLocationServiceView{

  Color getIconColor(){
    return Theme.of(currentContext()).brightness == Brightness.dark ? ColorCollections.titleColor : ColorCollections.shimmerBaseColor;
  }

  double getIconSize(){
    return MediaQuery.of(currentContext()).size.width * 3 / 4;
  }

  goToLandingPage(){
    NerbNavigator.instance.newClearRoute(currentContext(),child: LandingPage());
  }

  goToWrapperPermission(){
    NerbNavigator.instance.newClearRoute(currentContext(), child: WrapperPermission());
  }

  BuildContext currentContext(){
    return null;
  }

}