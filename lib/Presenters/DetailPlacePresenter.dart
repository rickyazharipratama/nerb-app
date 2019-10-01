import 'dart:async';

import 'package:dio/dio.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Response/SpecificDetailPlaceResponse.dart';
import 'package:nerb/PresenterViews/DetailPlaceView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class DetailPlacePresenter extends BasePresenter implements RequestResponseCallback{
  int _statusCode = 500;
  bool _isAlreadyRequest = false;
  SpecificDetailPlaceResponse _response;
  DetailPlaceView _view;
  String _href;

  String get href => _href;
  DetailPlaceView get view => _view;
  int get statusCode => _statusCode;
  bool get isAlreadyRequest => _isAlreadyRequest;
  SpecificDetailPlaceResponse get response => _response;

  set setView(DetailPlaceView vw){
    _view = vw;
  }

  set setStatusCode(int sc){
    _statusCode = sc;
  }

  set setAlreadyRequest(bool val){
    _isAlreadyRequest = val;
  }

  set setHref(String url){
    _href = url;
  }


   reloadRequest(){
     setAlreadyRequest = false;
     view.setViewState = 1;
     initiateData();
   }

  @override
  void initiateData() {
    super.initiateData();
    PlaceController.instance.getNearbyPlaceByNext(
      callback: this,
      language: "en",
      next: href
    );
  }

  @override
  void onFailureWithResponse(Response res) {
    setAlreadyRequest = false;
    setStatusCode = res.statusCode;
    view.setViewState = 2;
    view.onError();
  }

  @override
  void onSuccessResponseFailed(Response data) {
    if(data.statusCode == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyRequest){
        Timer(const Duration(seconds: 2),(){
          setAlreadyRequest = true;
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
    _response = SpecificDetailPlaceResponse.fromJson(data['result']);
    setAlreadyRequest = false;
    view.setViewState = 0;
    view.onSuccess();
  }

  @override
  void onfailure() {
    setAlreadyRequest = false;
    setStatusCode = 500;
    view.setViewState = 2;
    view.onError();
  }
}