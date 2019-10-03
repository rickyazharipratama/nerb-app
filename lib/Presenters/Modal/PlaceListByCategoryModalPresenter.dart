import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/rendering.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/PresenterViews/Modal/PlaceListByCategoryModalView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class PlaceListByCategoryModalPresenter extends BasePresenter implements RequestResponseCallback{

  PlaceListByCategoryModalView _view;
  List<FirestoreCategory> _categories;
  List<PlaceModel> _places;
  bool _isAlreadyRetry;
  int _statusCode;
  int _currPlaceVersion;
  bool _isNeedUpdate = false;
  PlaceModel _placeholder;
  ValueChanged<List<PlaceModel>> _onSelected;

  PlaceListByCategoryModalView get view => _view;
  set setView(PlaceListByCategoryModalView vw){_view = vw;}

  List<FirestoreCategory> get categories => _categories;
  set setCategories(List<FirestoreCategory> cat){
    if(_categories == null){
      _categories = List();
    }else{
      _categories.clear();
    }
    _categories.addAll(cat);
  }

  List<PlaceModel> get places => _places;
  set setPlaces(List<PlaceModel> plc){
    if(_places == null){
      _places = List();
    }else{
      _places.clear();
    }
    _places.addAll(plc);
  }

  bool get isAlreadyRetry => _isAlreadyRetry;
  set setAlreadyRetry(bool val){
    _isAlreadyRetry = val;
  }

  int get statusCode => _statusCode;
  set setStatusCode( int code){
    _statusCode = code;
  }

  int get currPlaceVersion => _currPlaceVersion;
  set setCurrPlaceVersion(int val){
    _currPlaceVersion = val;
  }

  bool get isNeedUpdate => _isNeedUpdate;
  set setNeedUpdate(bool val){
    _isNeedUpdate = val;
  }

  PlaceModel get placeholder => _placeholder;
  set setPlaceholder(PlaceModel placeHolder){
    _placeholder = placeHolder;
  }

  ValueChanged<List<PlaceModel>>  get onSelected => _onSelected;
  set setSelected(ValueChanged<List<PlaceModel>> val){
    _onSelected = val;
  }

  @override
  void initiateData() async{
    super.initiateData();
    RemoteConfig rc = await CommonHelper.instance.fetchRemoteConfig();
    int lastPlacesVersion = await PreferenceHelper.instance.getIntValue(
      key: ConstantCollections.PREF_LAST_PLACE_VERSION
    );
    if(lastPlacesVersion > 0){
      setCurrPlaceVersion = rc.getInt(ConstantCollections.REMOTE_CONFIG_PLACES_VERSION);
      if(lastPlacesVersion  < currPlaceVersion){
        setNeedUpdate = true;
      }
    }

    if(!isNeedUpdate){
      List<String> plcs = await PreferenceHelper.instance.getStringListValue(
        key: ConstantCollections.PREF_LAST_PLACE
      );
      if(plcs.length > 0){
        List<FirestoreCategory> tmpCategories = List();
        List<String> cat = await PreferenceHelper.instance.getStringListValue(
          key: ConstantCollections.PREF_LAST_CATEGORY
        );
        cat.forEach((ct){
          tmpCategories.add(FirestoreCategory(jsonDecode(ct)));
        });
        List<PlaceModel> tmpPlace = List();
        plcs.forEach((plc){
          tmpPlace.add(PlaceModel.fromStore(jsonDecode(plc)));
        });
        setCategories = tmpCategories;
        setPlaces = tmpPlace;
        view.onSuccess();
      }else{
        PlaceController.instance.getPlacesCategory(
          callback: this,
          lang: UserLanguage.of(view.currentContext()).currentLanguage
        );
      }
    }else{
      PlaceController.instance.getPlacesCategory(
        callback: this,
        lang: UserLanguage.of(view.currentContext()).currentLanguage
      );
    }
  }

  onTappedPlaceItem(dynamic item){
    List<PlaceModel>lst = List();
    lst.add(placeholder);
    lst.add(item);
    onSelected(lst);
  }


  @override
  void onFailureWithResponse(Response res) {
    setStatusCode = res.statusCode;
    setAlreadyRetry = false;
    view.onError();
  }

  @override
  void onSuccessResponseFailed(Response data) {
    if(data.statusCode == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyRetry){
        Timer(const Duration(seconds: 2), (){
          setAlreadyRetry = true;
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
    List<String>strTmp = List();
    for(Map<String, dynamic> dt in data['result'] as List<dynamic>){
      strTmp.add(jsonEncode(dt));
    }
    PreferenceHelper.instance.setStringListValue(
      key: ConstantCollections.PREF_LAST_PLACE,
      value: strTmp
    );
    if(isNeedUpdate){
      PreferenceHelper.instance.setIntValue(
        key: ConstantCollections.PREF_LAST_PLACE,
        value: currPlaceVersion
      );
    }
    List<String> cat = await PreferenceHelper.instance.getStringListValue(
      key: ConstantCollections.PREF_LAST_CATEGORY
    );

    List<FirestoreCategory> tmpCategories = List();
    cat.forEach((ct){
      tmpCategories.add(FirestoreCategory(jsonDecode(ct)));
    });
    setCategories = tmpCategories;

    List<PlaceModel> tmpPlace = List();
    strTmp.forEach((st){
      tmpPlace.add(PlaceModel.fromStore(jsonDecode(st)));
    });
    setPlaces = tmpPlace;
    view.onSuccess();
  }

  @override
  void onfailure() {
    onFailureWithResponse(Response(statusCode: 500));
  }
}