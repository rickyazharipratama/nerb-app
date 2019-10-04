import 'package:flutter/cupertino.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/Views/Pages/PlacesByCategory.dart';

class CategoryItemView{

  int _viewState = 1;


  int get viewState => _viewState;
  set setViewState(int vs){
    _viewState = vs;
  }

  BuildContext currentContext() => null;

  void goToPlacesByCategory(FirestoreCategory cat){
    NerbNavigator.instance.push(currentContext(), child: PlacesByCategory(
      category: cat,
      imageUrl: cat.imageStorage,
    ));
  }

}