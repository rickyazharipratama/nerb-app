import 'package:flutter/cupertino.dart';
import 'package:nerb/Callbacks/ViewCallback.dart';

class CategoriesView implements ViewCallback{
  
  int _viewState = 1;

  int get viewState => _viewState;
  set setViewState(int state){
    _viewState = state;
  }

  BuildContext currentContext() => null;

  @override
  void onError() {

  }

  @override
  void onSuccess() {

  }
}