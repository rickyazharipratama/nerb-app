import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';

class CommonHelper{

  static CommonHelper instance = CommonHelper();


  String getPlaceImagebyIconName({String icon}){
      if(icon.contains("geocode")){
        return "assets/placeholder_geocode.png";
      }else if(icon.toLowerCase().contains("atm") || icon.toLowerCase().contains("bank")){
        return "assets/placeholder_bank.png";
      }else if(icon.toLowerCase().contains("restaurant")){
        return "assets/placeholder_restaurant.png";
      }else if(icon.toLowerCase().contains("business") || icon.toLowerCase().contains("post_office")){
        return "assets/placeholder_business.png";
      }else if(icon.toLowerCase().contains("shopping") || icon.toLowerCase().contains("civic_building")){
        return "assets/placeholder_shopping.png";
      }else if(icon.toLowerCase().contains("school")){
        return "assets/placeholder_school.png";
      }else if(icon.toLowerCase().contains("lodging")){
        return "assets/placeholder_lodging.png";
      }
      return null;
  }

  forcePortraitOrientation(){
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  getTitleErrorByStatus({
    @required String status,
    @required BuildContext context
  }){
    if(status == ConstantCollections.RESPONSE_TIMEOUT){
      return UserLanguage.of(context).errorTitle("general");
    }else if(status == ConstantCollections.RESPONSE_INVALID_REQUEST){
      return UserLanguage.of(context).errorTitle("general");
    }else if(status == ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR){
      return UserLanguage.of(context).errorTitle("general");
    }
    return UserLanguage.of(context).errorTitle("general");
  }

  getDescErrorByStatus({
    @required String status,
    @required BuildContext context
  }){
    if(status == ConstantCollections.RESPONSE_TIMEOUT){
      return UserLanguage.of(context).errorDesc("general");
    }else if(status == ConstantCollections.RESPONSE_INVALID_REQUEST){
      return UserLanguage.of(context).errorDesc("general");
    }else if(status == ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR){
      return UserLanguage.of(context).errorDesc("general");
    }
    return UserLanguage.of(context).errorDesc("general");
  }

  getTitleErrorByCode({
    @required int code,
    @required BuildContext context
  }){
    return UserLanguage.of(context).errorTitle("general");
  }

  getDescErrorByCode({
    @required int code,
    @required BuildContext context
  }){
    return UserLanguage.of(context).errorDesc("general");
  }
}