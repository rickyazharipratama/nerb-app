import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Names.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/PresenterViews/Components/Collections/WrapperPlacesByCategoryView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class WrapperPlacesByCategoryPresenter extends BaseComponentPresenter implements RequestResponseCallback{
  WrapperPlacesByCategoryView _view;
  bool _isAlreadyRetry = false;
  int _statusCode;
  List<PlaceModel> _places;
  List<Names> _sections;
  bool _isNeedUpdate = false;
  int _currPlaceVersion = -1;
  final String category;

  WrapperPlacesByCategoryPresenter({this.category});

  WrapperPlacesByCategoryView get view => _view;
  set setView(WrapperPlacesByCategoryView vw){
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

  List<PlaceModel> get places => _places;
  set setPlaces(List<PlaceModel> plc){
    if(_places == null){
      _places = List();
    }else{
      _places.clear();
    }
    _places.addAll(plc);
  }

  List<Names> get sections => _sections;
  set setSections(List<Names> sct){
    if(_sections == null){
      _sections = List();
    }else{
      _sections.clear();
    }
    _sections.addAll(sct);
  }

  bool get isNeedUpdate => _isNeedUpdate;
  set setNeedUpdate(bool val){
    _isNeedUpdate = val;
  }
  int get currPlaceVersion => _currPlaceVersion;
  set setCurrPlaceVersion(int val){
    _currPlaceVersion = val;
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
       if(lastPlacesVersion < currPlaceVersion){
          setNeedUpdate = true;
       }
    }
    if(!isNeedUpdate){
      List<String> plcs = await PreferenceHelper.instance.getStringListValue(
        key: ConstantCollections.PREF_LAST_PLACE
      );
      if(plcs.length > 0){
        List<PlaceModel> tmpPlace = List();
        plcs.forEach((plc){
          tmpPlace.add(PlaceModel.fromStore(jsonDecode(plc)));
        });
        setPlaces = tmpPlace.where((pm)=> pm.categories.contains(category)).toList();
        places.sort((a,b) => UserLanguage.of(view.currentContext()).currentLanguage == ConstantCollections.LANGUAGE_ID ? a.section.id.compareTo(b.section.id) : a.section.en.compareTo(b.section.en));

        setSections = List();
        sections.add(places[0].section);
        places.forEach((plc){
          if(sections.where((sct) => (sct.id == plc.section.id && sct.en == plc.section.en)).toList().length == 0){
              sections.add(plc.section);
          }
        });
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

  goToPlaces(PlaceModel plc){
    FirebaseAnalyticHelper.instance.sendEvent(
      event: ConstantCollections.EVENT_SECTION_CLICKED,
      params: {
        'date':DateTime.now().toString(),
        'category':plc.categories[0],
        'name':plc.name
      }
    );
    view.goToPlace(plc);
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
          PlaceController.instance.getPlacesCategory(
            callback: this,
            lang: UserLanguage.of(view.currentContext()).currentLanguage
          );
        });
      }else{
        onFailureWithResponse(data);
      }
    }else{
      onFailureWithResponse(data);
    }
  }

  @override
  void onSuccessResponseSuccess(Map<String,dynamic> data) {
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
    List<PlaceModel> tmpPlace = List();
    strTmp.forEach((plc){
      tmpPlace.add(PlaceModel.fromStore(jsonDecode(plc)));
    });
    setPlaces = tmpPlace.where((tmp) => tmp.categories.contains(category)).toList();
    places.sort((a,b) => UserLanguage.of(view.currentContext()).currentLanguage == ConstantCollections.LANGUAGE_ID ? a.section.id.compareTo(b.section.id) : a.section.en.compareTo(b.section.en));
    setSections = List();
    sections.add(places[0].section);
    places.forEach((plc){
      if(sections.where((sct) => (sct.id == plc.section.id && sct.en == plc.section.en)).toList().length == 0){
        sections.add(plc.section);
      }
    });
    view.onSuccess();
  }

  @override
  void onfailure() {
    onFailureWithResponse(Response(statusCode: 500));
  }
}