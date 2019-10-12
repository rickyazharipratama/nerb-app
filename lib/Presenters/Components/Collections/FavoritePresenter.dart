import 'dart:async';
import 'dart:convert';

import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/PresenterViews/Components/Collections/FavoriteView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class FavoritePresenter extends BaseComponentPresenter{

  FavoriteView _view;
  List<PlaceModel> _favorites; 
  bool _isCategoryRetrieved = false;
  Stream<bool> _categoryStream;
  StreamSink _amSink;

  FavoritePresenter(Stream<bool> stream, StreamSink sinker){
    _categoryStream = stream;
    _categoryStream.listen(onRetrieveCategory);
    _amSink = sinker;
  }

  bool get isCategoryRetrieved => _isCategoryRetrieved;

  FavoriteView get view => _view;
  set setView(FavoriteView vw){
    _view = vw;
  }

  List<PlaceModel> get favorites => _favorites;
  set setFavorites(List<PlaceModel> fav){
    if(_favorites == null){
      _favorites = List();
    }else{
      _favorites.clear();
    }
    _favorites.addAll(fav);
  }

  @override
  void initiateData()async{
    super.initiateData();
    List<PlaceModel> tmpFavorites = new List();
    List<String> savedFavorites =  await PreferenceHelper.instance.getStringListValue(key: ConstantCollections.PREF_MY_FAVORITE);
    if(savedFavorites.length > 0){
      for(String fav in savedFavorites){
        tmpFavorites.add(PlaceModel.fromStore(json.decode(fav)));
      }
      updateFavorites(
        items: tmpFavorites
      );
    }else{
      setFavorites = List();
      for(int i = favorites.length; i < 8;i++){
        if(i == 7){
          favorites.add(PlaceModel.forOperator());
        }else{
          favorites.add(PlaceModel.emptyPlace(prefix: i.toString()));
        }
      }
      view.onSuccess();
    }
  }

  updateFavorites({List<PlaceModel> items}){
    setFavorites = items;
    CommonHelper.instance.showLog("before length : "+ favorites.length.toString());
    if(favorites.length < 7){
      for(int i = favorites.length; i < 8;i++){
        if(i == 7){
          favorites.add(PlaceModel.forOperator());
        }else{
          favorites.add(PlaceModel.emptyPlace(prefix: i.toString()));
        }
      }
    }else if(favorites.length > 8){
      List<PlaceModel> tmp = List()..addAll(favorites.getRange(0, 7));
      favorites.clear();
      favorites.addAll(tmp);
      favorites.add(PlaceModel.forOperator());
    }else{
      if(favorites.last.id != ConstantCollections.OPERATOR_FAVORITE){
        favorites.last.id = ConstantCollections.OPERATOR_FAVORITE;
      }
    }
    savingToStore();
    view.onSuccess();
  }
  
  savingToStore(){
    List<String> saved = List();
    favorites.forEach((place){
      saved.add(json.encode(place.getMap()));
    });
    PreferenceHelper.instance.setStringListValue(
      key: ConstantCollections.PREF_MY_FAVORITE,
      value: saved
    );
  }

  onDeletePlaceClicked(data){
    int idx = favorites.indexOf(data);
    if(idx >=0 && idx < favorites.length){
      FirebaseAnalyticHelper.instance.sendEvent(
        event: ConstantCollections.EVENT_REMOVE_FAVORITE_SECTION,
        params: {
          "date": DateTime.now().toString(),
          "section-name": favorites[idx].name,
          "category": favorites[idx].categories
        }
      );
      favorites[idx] = PlaceModel.emptyPlace(prefix: DateTime.now().millisecondsSinceEpoch.toString());
      savingToStore();
      view.notifyState();
    }
  }

  turnOnEditMode(){
    int diff = favorites.length - favorites.where((place) => place.id.startsWith(ConstantCollections.EMPTY_FAVORITE)).length;
    if(diff > 1){
      view.setEditMode = true;
      FirebaseAnalyticHelper.instance.sendEvent(
        event: ConstantCollections.EVENT_START_UPDATING_FAVORITE,
        params: {
          "date": DateTime.now().toString()
        }
      );
      view.notifyState();
    }else{
      view.showErrorModal(
        title: UserLanguage.of(view.currentContext()).errorTitle("favoriteIsEmpty"),
        desc: UserLanguage.of(view.currentContext()).errorDesc("favoriteIsEmpty")
      );
    }
  }

  turnOffEditMode(){
    view.setEditMode = false;
    FirebaseAnalyticHelper.instance.sendEvent(
      event: ConstantCollections.EVENT_FINISH_UPDATING_FAVORITE,
      params: {
        "date": DateTime.now().toString()
      }
    );
    view.notifyState();
  }

  showPlaceList(trigger) async{
    if(!view.isEditMode){
      _amSink.add(1);
      view.showPlaceList(
        onSelectedPlace: onSelectedPlace,
        trigger: trigger
      );
    }
  }

  onSelectedPlace(item){
    if(item != null){
      if(favorites.where((place)=> place.forSearch == item[1].forSearch).length > 0){
        view.showErrorModal(
          title: UserLanguage.of(view.currentContext()).errorTitle("placeIsAlreadyExist"),
          desc: UserLanguage.of(view.currentContext()).errorDesc('placeIsAlreadyExist')
        );
      }else{
        int idx = favorites.indexOf(item[0]);
        favorites[idx] = item[1];
        savingToStore();
        FirebaseAnalyticHelper.instance.sendEvent(
          event: ConstantCollections.EVENT_SELECT_FAVORITE_SECTION,
          params: {
            "date": DateTime.now().toString(),
            "category":(item[1] as PlaceModel).categories,
            "section-name":(item[1] as PlaceModel).name
          }
        );
        _amSink.add(0);
        view.notifyState();
      }
    }
  }

  onRetrieveCategory(bool isDone){
    CommonHelper.instance.showLog("it'scalled");
    if(isDone){
      _isCategoryRetrieved = true;
      view.notifyState();
    }
  }

}