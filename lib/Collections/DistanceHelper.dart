import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';

class DistanceHelper{

  static DistanceHelper instance = DistanceHelper();


  double getDistance({@required double fromLat, @required double fromLong, @required double toLat, @required double toLong}){

    double earthRadius = 6371;
    double deltaLat = (toLat - fromLat) * (pi/180);
    double deltaLong = (toLong - fromLong) * (pi/180);
    double a = pow(sin(deltaLat / 2), 2) + (cos(fromLat) * cos(toLat) * pow(sin(deltaLong/2),2));
    double c = 2 * atan2(sqrt(a), sqrt(1 -a));
    return (earthRadius * c);
  }
  double getMeter(double distance){
    return distance * 1000;
  }
  String getFormatDistance(BuildContext context,double distance){
    NumberFormat format =  NumberFormat("###,###",UserLanguage.of(context).currentLanguage);
    return format.format(distance >=1 ? distance : getMeter(distance))+(distance >=1 ? " KM" : " M");
  }
}