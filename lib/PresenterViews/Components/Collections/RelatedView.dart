import 'package:flutter/material.dart';
import 'package:nerb/Callbacks/ViewCallback.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Pages/DetailPlaces.dart';

class RelatedView implements ViewCallback{

  int _viewState = 1;

  set setViewState(int state){
    _viewState = state;
  }
  int get viewState => _viewState;

  BuildContext currentContext() => null;

  remNPushToDetailPlace({
    DetailNearbyPlaceResponse place,
    String img
  }){
    NerbNavigator.instance.removeThenPush(currentContext(),
      child: DetailPlaces(
        place : place,
        img: img,
      )
    );
  }

  void notifyState(){}

  @override
  void onError() {
  }

  @override
  void onSuccess() {
  }
}