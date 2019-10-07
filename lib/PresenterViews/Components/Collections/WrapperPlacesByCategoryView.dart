import 'package:flutter/cupertino.dart';
import 'package:nerb/Callbacks/ViewCallback.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/Views/Pages/Places.dart';

class WrapperPlacesByCategoryView implements ViewCallback{

  int _viewState = 1;

  int get viewState => _viewState;
  set setViewState(int state){
    _viewState = state;
  } 

  BuildContext currentContext() => null;

  goToPlace(PlaceModel place){
    NerbNavigator.instance.push(currentContext(),
      child: Places(
        title: UserLanguage.of(currentContext()).currentLanguage == ConstantCollections.LANGUAGE_ID ? place.name.id : place.name.en,
        forSearch: place.forSearch,
      )
    );
  }

  @override
  void onError() {

  }

  @override
  void onSuccess() {

  }

}