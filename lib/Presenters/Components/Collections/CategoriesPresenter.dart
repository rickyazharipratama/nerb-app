import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/PresenterViews/Components/Collections/CategoriesView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class CategoriesPresenter extends BaseComponentPresenter implements RequestResponseCallback{

  CategoriesView _view;
  int _statusCode = 500;
  bool _isAlreadyRetry = false;
  bool _isNeedUpdate = false;
  int _currCategoryVersion = -1;
  List<FirestoreCategory> _categories;
  StreamSink _sinker;


  CategoriesPresenter(StreamSink sinker){
    _sinker = sinker;
  }
  
  CategoriesView get view => _view;
  set setView(CategoriesView vw){
    _view = vw;
  }

  int get statusCode => _statusCode;
  set setStatusCode( int code){
    _statusCode = code;
  }

  bool get isAlreadyRetry => _isAlreadyRetry;
  set setAlreadyReatry( bool val){
    _isAlreadyRetry = val;
  }
  
  bool get isNeedUpdate => _isNeedUpdate;
  set setNeedUpdate(bool val){
    _isNeedUpdate = val;
  }

  int get currCategoryVersion => _currCategoryVersion;
  set setCurrCategoryVersion(int version){
    _currCategoryVersion = version;
  }

  List<FirestoreCategory> get categories => _categories;
  set setCategories(List<FirestoreCategory> cat){
    if(_categories == null){
      _categories = List();
    }else{
      _categories.clear();
    }
    _categories.addAll(cat);
  }

  @override
  void initiateData() async{
    super.initiateData();
    RemoteConfig rc = await CommonHelper.instance.fetchRemoteConfig();
    int lastCategoryVersion = await PreferenceHelper.instance.getIntValue(
      key: ConstantCollections.PREF_LAST_CATEGORY_VERSION
    );
    if(lastCategoryVersion > 0){
      setCurrCategoryVersion = rc.getInt(ConstantCollections.REMOTE_CONFIG_CATEGORY_VERSION);
      if(lastCategoryVersion < currCategoryVersion){
        setNeedUpdate = true;
      }
    }
    if(!isNeedUpdate){
      List<String> prefCat = await PreferenceHelper.instance.getStringListValue(key: ConstantCollections.PREF_LAST_CATEGORY);
      if(prefCat.length > 0){
        List<FirestoreCategory> tmpCategories = List();
        prefCat.forEach((cat){
          tmpCategories.add(FirestoreCategory(jsonDecode(cat)));
        });
        setCategories = tmpCategories;
        categories.sort((a,b)=> UserLanguage.of(view.currentContext()).currentLanguage == ConstantCollections.LANGUAGE_ID ? a.name.id.compareTo(b.name.id) : a.name.en.compareTo(b.name.en));
        CommonHelper.instance.showLog("leng categories : "+categories.length.toString());
        _sinker.add(true);
        view.onSuccess();
      }else{
        PlaceController.instance.getCategories(
          callback: this,
          lang: UserLanguage.of(view.currentContext()).currentLanguage
        );
      }
    }else{
      PlaceController.instance.getCategories(
        callback: this,
        lang: UserLanguage.of(view.currentContext()).currentLanguage
      );
    }
  }

  @override
  void onFailureWithResponse(Response res) {
    setAlreadyReatry = false;
    setStatusCode = res.statusCode;
    view.onError();
  }

  @override
  void onSuccessResponseFailed(Response data) {
    if(data.statusCode == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyRetry){
        setAlreadyReatry = true;
        Timer(const Duration(seconds: 2),(){
          PlaceController.instance.getCategories(
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
  void onSuccessResponseSuccess(Map<String, dynamic> data) {
    List<String> tmp = List();
    for(Map<String,dynamic> dt in data['result'] as List<dynamic>){
      tmp.add(jsonEncode(dt));
    }
    PreferenceHelper.instance.setStringListValue(
      key: ConstantCollections.PREF_LAST_CATEGORY,
      value: tmp
    );
    List<FirestoreCategory> tmpCat = List();
    tmp.forEach((tp){
      tmpCat.add(FirestoreCategory(jsonDecode(tp)));
    });
    setCategories = tmpCat;
    this.categories.sort((a,b)=> UserLanguage.of(view.currentContext()).currentLanguage == ConstantCollections.LANGUAGE_ID ? a.name.id.compareTo(b.name.id) : a.name.en.compareTo(b.name.en));
    CommonHelper.instance.showLog("categories leng : "+this.categories.length.toString());
    _sinker.add(true);
    view.onSuccess();
  }

  @override
  void onfailure() {
    onFailureWithResponse(Response(statusCode: 500));
  }
}