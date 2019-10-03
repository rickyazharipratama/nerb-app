import 'package:flutter/cupertino.dart';
import 'package:nerb/Callbacks/ViewCallback.dart';

class PlaceListByCategoryModalView implements ViewCallback{

  int _viewState = 1;

  int get viewState => _viewState;
  set setViewState(int val){
    _viewState = val;
  }

  BuildContext currentContext() => null;

  double getWidth(){
    return MediaQuery.of(currentContext()).size.width;
  }

  @override
  void onError() {
  }

  @override
  void onSuccess() {
  }
}