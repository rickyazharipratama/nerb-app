import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:nerb/Collections/ConstantCollections.dart';

class APICollections{

  
  final String baseMapEndpoint = ConstantCollections.ENVIRONMENT == ConstantCollections.PROD ? "https://api.nerb-app.fun": "http://127.0.0.1/nerb-api";

  static APICollections instance = APICollections();

  String getCategories(){
    return baseMapEndpoint+"/api/places/getCategories?token="+_provideToken();
  }

  String getCategoryPlaces(){
    return baseMapEndpoint+"/api/places/getCategoryPlace?token="+_provideToken();
  }

  String getListPlace({
    @required String location,
    String cat
  }){
    return baseMapEndpoint+"/api/places/getListPlace?in="+location+"&token="+_provideToken()+(cat != null ?"&cat="+cat:"");
  }

  String getListPlaceByNext({
    @required String next
  }){
    return baseMapEndpoint+"/api/places/getListPlace?token="+_provideToken()+"&next="+next;
  }


  String _provideToken(){
    DateTime dt = DateTime.now().toUtc();
    String plain = ConstantCollections.PREFIX+"-"+dt.year.toString()+(dt.month > 9 ?dt.month.toString() : "0"+dt.month.toString())+(dt.day > 9 ? dt.day.toString() : "0"+dt.day.toString())+(dt.hour > 9 ?dt.hour.toString() : "0"+dt.hour.toString())+(dt.minute > 9 ? dt.minute.toString() :"0"+dt.minute.toString());
    debugPrint(plain);
    var bytes = utf8.encode(plain);
    var hash = sha256.convert(bytes);
    debugPrint(hash.toString());
    return hash.toString();
  }
}