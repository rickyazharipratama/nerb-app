import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/StringHelper.dart';

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
    @required String lang
  }){
    if(status == ConstantCollections.RESPONSE_TIMEOUT){
      return StringHelper.instance.getCollections[lang]['errTitleGeneral'];
    }else if(status == ConstantCollections.RESPONSE_INVALID_REQUEST){
      return StringHelper.instance.getCollections[lang]['errTitleGeneral'];
    }else if(status == ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR){
      return StringHelper.instance.getCollections[lang]['errTitleGeneral'];
    }
    return StringHelper.instance.getCollections[lang]['errTitleGeneral'];
  }

  getDescErrorByStatus({
    @required String status,
    @required String lang
  }){
    if(status == ConstantCollections.RESPONSE_TIMEOUT){
      return StringHelper.instance.getCollections[lang]['errDesceGeneral'];
    }else if(status == ConstantCollections.RESPONSE_INVALID_REQUEST){
      return StringHelper.instance.getCollections[lang]['errDescGeneral'];
    }else if(status == ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR){
      return StringHelper.instance.getCollections[lang]['errDescGeneral'];
    }
    return StringHelper.instance.getCollections[lang]['errDescGeneral'];
  }

  getTitleErrorByCode({
    @required int code,
    @required String lang
  }){
    return StringHelper.instance.getCollections[lang]['errTitleGeneral'];
  }

  getDescErrorByCode({
    @required int code,
    @required String lang
  }){
    return StringHelper.instance.getCollections[lang]['errDescGeneral'];
  }

}