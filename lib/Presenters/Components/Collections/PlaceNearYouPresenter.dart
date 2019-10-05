import 'dart:async';

import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Response/NearbyPlaceResponse.dart';
import 'package:nerb/PresenterViews/Components/Collections/PlaceNearYouView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class PlaceNearYouPresenter extends BaseComponentPresenter implements RequestResponseCallback{

  PlaceNearYouView _view;
  bool _isAlreadyRetry = false;
  int _statusCode = 500;
  NearbyPlaceResponse _nearby;
  Location _currentLocation;

  PlaceNearYouView get view => _view;
  set setView(PlaceNearYouView vw){
    _view = vw;
  }

  bool get isAlreadyRetry => _isAlreadyRetry;
  set setAlreadyRetry(bool val){
    _isAlreadyRetry = val;
  }

  int get statusCode => _statusCode;
  set setStatusCode(int val){
    _statusCode = val;
  }

  NearbyPlaceResponse get nearby => _nearby;
  set setNearby(NearbyPlaceResponse val){
    _nearby = val;
  }

  Location get currentLocation => _currentLocation;
  set setCurrentLocation(Location loc){
    _currentLocation = loc;
  }


  @override
  void initiateData() async{
    super.initiateData();
    setCurrentLocation = Location();
    LocationData dt = await currentLocation.getLocation();
    int radius = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);
    PlaceController.instance.getNearbyPlace(
      callback: this,
      language: UserLanguage.of(view.currentContext()).currentLanguage,
      location: dt.latitude.toString()+","+dt.longitude.toString(),
      radius: radius.toString()
    );

  }

  @override
  void onFailureWithResponse(Response res) {
    setAlreadyRetry = false;
    setStatusCode = res.statusCode;
    view.onError();
  }

  @override
  void onSuccessResponseFailed(Response data) {
    if(data.statusCode == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyRetry){
        setAlreadyRetry = true;
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
  void onSuccessResponseSuccess(Map<String,dynamic> data) async{
    setNearby = NearbyPlaceResponse.fromJson(data['result']);
    nearby.setLastFetch = DateTime.now().millisecondsSinceEpoch;
    LocationData dt = await currentLocation.getLocation();
    PreferenceHelper.instance.setStringValue(
      key: ConstantCollections.PREF_LAST_LOCATION,
      value: dt.latitude.toString()+","+dt.longitude.toString()
    );
    setAlreadyRetry = false;
    view.onSuccess();
  }

  @override
  void onfailure() {
    onFailureWithResponse(Response(statusCode: 500));
  }
}