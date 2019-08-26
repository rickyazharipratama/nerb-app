
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/APICollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NetworkHelper.dart';

class PlaceController{

  static PlaceController instance = PlaceController();

  getNearbyPlace({String type, @required String location, @required String radius, @required String language, @required RequestResponseCallback callback}){
    NetworkHelper.instance(language).requestGet(
      path: APICollections.instance.getListPlace(
        location: location+";r="+radius,
        cat: type
      )
    ).then((res){
      if(res != null){
        if(res.data != null){
          Map<String,dynamic> json = res.data;
          print(jsonEncode(res.data));
          if(json['status'] == ConstantCollections.STATUS_SUCCESS){
            callback.onSuccessResponseSuccess(json);
          }else{
            json['statusCode'] = res.statusCode;
            callback.onSuccessResponseFailed(res);
          }
        }else{
          callback.onFailureWithResponse(res);
        }
      }else{
        callback.onfailure();
      }
    }).catchError((error){
      print(error);
      callback.onfailure();
    });
  }

  getNearbyPlaceByNext({@required String next, @required language,@required RequestResponseCallback callback}){
    NetworkHelper.instance(language).requestGet(
      path: APICollections.instance.getListPlaceByNext(
        next: next
      )
    ).then((res){
      if(res != null){
        if(res.data != null){
           Map<String,dynamic> data = res.data;
           print(jsonEncode(res.data));
           if(data['status'] == ConstantCollections.STATUS_SUCCESS){
             callback.onSuccessResponseSuccess(data);
           }else{
             data['statusCode'] = res.statusCode;
             callback.onSuccessResponseFailed(res);
           }
        }else{
          callback.onFailureWithResponse(res);
        }
      }else{
        callback.onfailure();
      }
    }).catchError((error){
      print(error);
      callback.onfailure();
    });
  }

  getCategories({@required RequestResponseCallback callback, @required String lang}){
    NetworkHelper.instance(lang).requestGet(
      path: APICollections.instance.getCategories()
    ).then((res){
      if(res != null){
        if(res.data != null){
          print(jsonEncode(res.data));
          if(res.data['status'] == ConstantCollections.STATUS_SUCCESS){
            callback.onSuccessResponseSuccess(res.data);
          }else{
            callback.onSuccessResponseFailed(res);
          }
        }else{
          callback.onFailureWithResponse(res);
        }
      }else{
        callback.onfailure();
      }
    }).catchError((error){
      print(error);
      callback.onfailure();
    });
  }

  getPlacesCategory({@required RequestResponseCallback callback, @required String lang}){
    NetworkHelper.instance(lang).requestGet(
      path: APICollections.instance.getCategoryPlaces()
    ).then((res){
      if(res != null){
        if(res.data != null){
          print(jsonEncode(res.data));
          if(res.data['status'] == ConstantCollections.STATUS_SUCCESS){
            callback.onSuccessResponseSuccess(res.data);
          }else{
            res.data['statusCode'] = res.statusCode;
            callback.onSuccessResponseFailed(res);
          }
        }else{
          callback.onFailureWithResponse(res);
        }
      }
    }).catchError((error){
      print(error);
      callback.onfailure();
    });
  }
}