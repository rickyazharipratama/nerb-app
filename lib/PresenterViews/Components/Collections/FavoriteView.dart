import 'package:flutter/material.dart';
import 'package:nerb/Callbacks/ViewCallback.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/Views/Modals/ErrorModal.dart';
import 'package:nerb/Views/Modals/PlacesListByCategoryModal.dart';

class FavoriteView implements ViewCallback{

  int _viewState = 1;
  bool _isEditMode = false;

  int get viewState => _viewState;
  set setViewState(int val){
    _viewState = val;
  }

  bool get isEditMode => _isEditMode;
  set setEditMode(bool val){
    _isEditMode = val;
  }

  BuildContext currentContext(){
    return null;
  }

  void showErrorModal({
    @required String title,
    @required String desc
  }){
    showModalBottomSheet(
      context: currentContext(),
      builder: (_) => ErrorModal(
        title: title,
        desc: desc,
      )
    );
  }

  void showPlaceList({
    ValueChanged onSelectedPlace,
    PlaceModel trigger
  }){
    showBottomSheet(
        context: currentContext(),
        builder: (context){
          return PlacesListByCategoryModal(
            onSelected: onSelectedPlace,
            placeHolder: trigger,
          );
        }
      );
  }

  @override
  void onError() {
  }

  @override
  void onSuccess() {
  }

  void notifyState(){}
}