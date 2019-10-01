import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Views/Pages/Splash.dart';

class MaintenanceView{

  Color getColorIcon(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark ? ColorCollections.titleColor : ColorCollections.shimmerBaseColor;
  }

  double getIconSize(BuildContext context){
    return MediaQuery.of(context).size.width * 3 / 4;
  }

  alreadyDoneMaintenance(){
    NerbNavigator.instance.newClearRoute(currentContext(), child: Splash());
  }

  BuildContext currentContext(){return null;}
}