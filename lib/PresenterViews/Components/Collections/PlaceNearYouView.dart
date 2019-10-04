import 'package:flutter/cupertino.dart';
import 'package:nerb/Callbacks/ViewCallback.dart';

class PlaceNearYouView implements ViewCallback{
  int _viewState = 1;

  int get viewState => _viewState;
  set setViewState(int val){
    _viewState = val;
  }

  BuildContext currentContext() => null;

  @override
  void onError() {}

  @override
  void onSuccess() {}

}