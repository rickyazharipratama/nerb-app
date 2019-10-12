import 'dart:async';

import 'package:dio/dio.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Models/Response/NearbyPlaceResponse.dart';
import 'package:nerb/PresenterViews/Components/Collections/RelatedView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class RelatedPresenter extends BaseComponentPresenter implements RequestResponseCallback{

  RelatedView _view;
  int _statusCode = 500;
  bool _isAlreadyRequired = false;
  NearbyPlaceResponse _places;
  final String type;
  final String href;

  RelatedPresenter({this.href, this.type});

  RelatedView get view => _view;
  set setView(RelatedView vw){
    _view = vw;
  }

  int get statusCode => _statusCode;
  set setStatusCode(int code){
    _statusCode = code;
  }

  bool get isAlreadyRequired => _isAlreadyRequired;
  set setAlreadyRequired(bool val){
    _isAlreadyRequired = val;
  }

  NearbyPlaceResponse get places => _places;

  @override
  void initiateData() {
    super.initiateData();
    PlaceController.instance.getNearbyPlaceByNext(
      callback: this,
      language: "en",
      next: href
    );
  }

  String getImage(DetailNearbyPlaceResponse plc){
    String img = CommonHelper.instance.getPlaceImageByCategory(category: plc.category.id.toLowerCase());
    if(img == null){
      if(plc.category.title.contains("/")){
        List<String> plcs = plc.category.title.split("/");
        for(int i= 0; i < plcs.length; i++){
          img = CommonHelper.instance.getPlaceImageByCategory(category: plcs[i].toLowerCase());
          if(plc != null){
            i = plcs.length;
          }
        }
      }else{
        img = CommonHelper.instance.getPlaceImageByCategory(category: plc.category.title.toLowerCase());
      }
    }
    return img;
  }

  @override
  void onFailureWithResponse(Response res) {
    setAlreadyRequired = false;
    setStatusCode = res.statusCode;
    view.onError();
  }

  @override
  void onSuccessResponseFailed(Response data) {
    if(data.statusCode == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyRequired){
        Timer(const Duration(seconds: 2), (){
          initiateData();
        });
      }else{
        onFailureWithResponse(data);
      }
    }else{
      onFailureWithResponse(data);
    }
  }

  @override
  void onSuccessResponseSuccess(Map<String,dynamic> data) {
    CommonHelper.instance.showLog("gather related is success");
    _places = NearbyPlaceResponse.fromNextResponse(data['result']);
    setAlreadyRequired = false;
    view.onSuccess();
  }

  @override
  void onfailure() {
    onFailureWithResponse(Response(statusCode: 500));
  }

  void goToDetailPlace(DetailNearbyPlaceResponse plc){
    FirebaseAnalyticHelper.instance.sendEvent(
      event: type == ConstantCollections.RELATED_NEARBY ?
        ConstantCollections.EVENT_OPEN_DETAIL_PLACES_BY_NEARBY
        : ConstantCollections.EVENT_OPEN_DETAIL_PLACES_BY_TRANSPORT,
      params: {
        'date': DateTime.now().toString(),
        'category':plc.category.title,
        'name':plc.title
      }
    );
    view.remNPushToDetailPlace(
      img: getImage(plc),
      place: plc
    );
  }
}