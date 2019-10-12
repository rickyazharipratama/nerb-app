
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Response/NearbyPlaceResponse.dart';
import 'package:nerb/PresenterViews/PlaceView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class PlacePresenter extends BasePresenter implements RequestResponseCallback{

  PlaceView _view;
  NearbyPlaceResponse _response;
  String _nextToken;
  Location _currentLocation;
  int _statusCode = 500;
  bool _isAlreadyretry = false;
  int _requestMode = 0;
  bool _isProcessRequest = false;
  String _forSearch;



  PlaceView get view => _view;
  set setView(PlaceView vw){
    _view = vw;
  }

  NearbyPlaceResponse get response => _response;

  String get nextToken => _nextToken;
  set setNextToken(String token){_nextToken = token;}

  Location get currentLocation => _currentLocation;

  int get statusCode => _statusCode;
  set setStatusCode(int code){_statusCode = code;}

  bool get isAlreadyRetry => _isAlreadyretry;
  set setAlreadyRetry(bool val){
    _isAlreadyretry = val;
  }

  int get requestMode => _requestMode;
  set setRequestMode(int mode){
    _requestMode = mode;
  }

  bool get isProcessRequest => _isProcessRequest;
  set setProcessRequest(bool val){_isProcessRequest = val;}

  String get forSearch => _forSearch;
  set setForSearch(String search){
    _forSearch = search;
  }

  @override
  initiateData() async{
    super.initiateData();
    setRequestMode = 0;
    _currentLocation = Location();
    LocationData dt = await currentLocation.getLocation();
    int radius = await PreferenceHelper.instance.getIntValue(
      key: ConstantCollections.PREF_RADIUS
    );
    setProcessRequest = true;
    FirebaseAnalyticHelper.instance.setScreen(
      screen: "Places"
    );
    PlaceController.instance.getNearbyPlace(
      callback: this,
      language: UserLanguage.of(view.currentContext()).currentLanguage,
      location: dt.latitude.toString()+","+dt.longitude.toString(),
      radius: radius.toString(),
      type: forSearch
    );
  }

  requestAffectByScroll(){
    if(view.isEndOfBottomScroll()){
      if(!isProcessRequest){
        if(response != null){
          if(response.getNext != null){
            view.onEndScrolling();
          }
        }else{
          CommonHelper.instance.showLog("There is no data");
        }
      }else{
        CommonHelper.instance.showLog("there is another request running");
      }
    }
  }

  getPlaceRequestByScroll(){
    setRequestMode = 1;
    setProcessRequest = true;
    PlaceController.instance.getNearbyPlaceByNext(
      language: UserLanguage.of(view.currentContext()).currentLanguage,
      callback: this,
      next: response.getNext
    );
  }

  @override
  void onFailureWithResponse(Response res) {
    setProcessRequest = false;
    setStatusCode = res.statusCode;
    view.onError();
    if(requestMode != 0){
      view.showErrorBottomModal(res.statusCode);
    }
  }

  @override
  void onSuccessResponseFailed(Response data) {
    if(requestMode == 0){
      if(data.statusCode == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
        if(!isAlreadyRetry){
          Timer(
            const Duration(seconds: 2),
            (){
              setAlreadyRetry = true;
              setProcessRequest = false;
              initiateData();
            }
          );
        }else{
          onFailureWithResponse(data);
        }
      }else{
        onFailureWithResponse(data);
      }
    }else{
      if(data.statusCode == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
        if(!isAlreadyRetry){
          setAlreadyRetry = true;
          Timer(
            const Duration(seconds: 2),
            (){
              setAlreadyRetry = true;
              setProcessRequest = false;
              getPlaceRequestByScroll();
            }
          );
        }else{
          onFailureWithResponse(data);
        }
      }else{
        onFailureWithResponse(data);
      }
    }
  }

  @override
  void onSuccessResponseSuccess(Map<String,dynamic> data)async{
    if(requestMode == 0){
      _response = NearbyPlaceResponse.fromJson(data['result']);
      _response.setLastFetch = DateTime.now().millisecondsSinceEpoch;
      LocationData dt = await currentLocation.getLocation();

      PreferenceHelper.instance.setStringValue(
        key: ConstantCollections.PREF_LAST_LOCATION,
        value: dt.latitude.toString()+","+dt.longitude.toString()
      );
    }else{
      NearbyPlaceResponse tmp = NearbyPlaceResponse.fromNextResponse(data['result']);
      if(tmp.next != null){
        _response.setNext = tmp.next;

      }else{
        _response.setNext = null;
      }

      if(tmp.getNearbyPlaces != null){
        if(tmp.getNearbyPlaces.length > 0){
          _response.setNearbyPlace = tmp.nearbyPlaces;
        }
      }
    }
    setProcessRequest = false;
    view.onSuccess();
  }

  @override
  void onfailure() {
    setProcessRequest = false;
    setStatusCode = 500;
    view.onError();
    if(requestMode != 0){
      view.showErrorBottomModal(statusCode);
    }
  }

}