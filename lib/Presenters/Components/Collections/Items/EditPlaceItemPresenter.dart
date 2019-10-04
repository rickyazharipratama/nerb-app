import 'package:flutter/rendering.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/PresenterViews/Components/Collections/Items/EditPlaceItemView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class EditPlaceItemPresenter extends BaseComponentPresenter{

  EditPlaceItemView _view;
  PlaceModel _place;
  ValueChanged _onDeleteClick;

  EditPlaceItemView get view => _view;
  set setView(EditPlaceItemView vw){
    _view = vw;
  }

  PlaceModel get place => _place;
  set setPlace(PlaceModel plc){
    _place = plc;
  }

  ValueChanged get onDeleteClick => _onDeleteClick;
  set setOnDeleteClick(ValueChanged del){
    _onDeleteClick = del;
  }

  @override
  void initiateData() {
    super.initiateData();
  }
}