import 'dart:convert';

import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/APICollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NetworkHelper.dart';

class PlaceController{

  static PlaceController instance = PlaceController();

  getNearbyPlace({String type, String location, String radius, String pageToken, RequestResponseCallback callback, String language}){

    NetworkHelper.instance.requestGet(
      path: APICollections.instance.apiNearbyPlace(
        location: location,
        pageToken: pageToken,
        radius: radius,
        language: language,
        type: type
      )
    ).then((res){
      
      if(res != null){
         if(res.data != null){
           print(json.encode(res.data));
           Map<String,dynamic> respon = res.data;
           if(respon['status'] == ConstantCollections.RESPONSE_OK){
             callback.onSuccessResponseSuccess(respon);
           }else{
             callback.onSuccessResponseFailed(respon);
           }
         }else{
           callback.onFailureWithResponse(res);
         }
      }else{
        callback.onfailure();
      }
    })
    .catchError((err){
      callback.onfailure();
    });
  }
}