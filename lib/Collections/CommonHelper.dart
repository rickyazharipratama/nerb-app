import 'package:flutter/services.dart';

class CommonHelper{

  static CommonHelper instance = CommonHelper();


  String getPlaceImagebyIconName({String icon}){
      if(icon.contains("geocode")){
        return "assets/placeholder_geocode.png";
      }else if(icon.toLowerCase().contains("atm") || icon.toLowerCase().contains("bank")){
        return "assets/placeholder_bank.png";
      }else if(icon.toLowerCase().contains("restaurant")){
        return "assets/placeholder_restaurant.png";
      }else if(icon.toLowerCase().contains("business")){
        return "assets/placeholder_business.png";
      }else if(icon.toLowerCase().contains("shopping")){
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

}