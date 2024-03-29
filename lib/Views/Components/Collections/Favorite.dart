import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/Views/Components/Collections/Items/AddFavoritesItem.dart';
import 'package:nerb/Views/Components/Collections/Items/EditPlaceItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimerFavorite.dart';
import 'package:nerb/Views/Components/misc/Separator.dart';
import 'package:nerb/Views/Modals/ErrorModal.dart';
import 'package:nerb/Views/Modals/PlacesListByCategoryModal.dart';
import 'package:nerb/Views/Pages/Places.dart';

import 'Items/PlaceItem.dart';

class Favorite extends StatefulWidget {

  final VoidCallback openingPlace;
  final VoidCallback closingPlace;
  final bool isCategoryRetrieve;

  Favorite({@required this.openingPlace, @required this.closingPlace,  this.isCategoryRetrieve : false});

  @override
  _FavoriteState createState() => new _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  List<PlaceModel> favorites = new List();
  int viewState = 1;

  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
        initiateData();
    }
    
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: SectionTitle.withText(
                value: UserLanguage.of(context).title("favorite"),
              ),
            ),

          Separator(),

            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: widget.isCategoryRetrieve ?
                viewState == 0 ? 
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: favorites.getRange(0, 4).map((fav){
                        return fav.id.startsWith(ConstantCollections.EMPTY_FAVORITE) ?
                            AddFavoritesItem(
                              callback: showPlaceList,
                              place: fav,
                            )
                            : isEditMode ?
                                EditPlaceItem(
                                  onDeleteClick: onDeletePlaceClicked,
                                  place: fav,
                                )
                              : PlaceItem(
                                place: fav,
                                callback: (place){
                                  NerbNavigator.instance.push(context,
                                    child: Places(
                                      title: UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? place.name.id : place.name.en,
                                      forSearch: place.forSearch,
                                    )
                                  );
                                },
                              );
                      }).toList(),
                    ),

                    Padding(padding: const EdgeInsets.only(top: 10)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: favorites.getRange(4, favorites.length).map((fav){
                        
                        return fav.id.startsWith(ConstantCollections.EMPTY_FAVORITE) ? 
                              AddFavoritesItem(
                                callback: showPlaceList,
                                place: fav,
                              )
                            : fav.id == ConstantCollections.OPERATOR_FAVORITE ?
                              InkWell(
                                onTap: isEditMode ? turnOffEditMode : turnOnEditMode,
                                borderRadius: BorderRadius.circular(25),
                                splashColor: ColorCollections.shimmerHighlightColor,
                                highlightColor: ColorCollections.shimmerBaseColor,
                                child: Container(
                                  width: 65,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isEditMode ? Colors.red : Theme.of(context).highlightColor,
                                      width: 1,
                                    ),
                                    color: isEditMode ? Colors.red : Theme.of(context).highlightColor,
                                    shape: BoxShape.circle
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isEditMode ? Icons.close : Icons.edit,
                                      color: isEditMode ? Colors.white : Theme.of(context).buttonColor,
                                      size: 25,
                                    ),
                                  )
                                ),
                              )
                              : isEditMode ?
                                EditPlaceItem(
                                  onDeleteClick: onDeletePlaceClicked,
                                  place: fav,
                                )
                                : PlaceItem(
                                    place: fav,
                                    callback: (place){
                                      NerbNavigator.instance.push(context,
                                        child: Places(
                                          title: UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? place.name.id : place.name.en,
                                          forSearch: place.forSearch,
                                        )
                                      );
                                    },
                                  );
                      }).toList(),
                    )
                  ],
                )
                : ShimmerFavorite()
              : ShimmerFavorite(),
            ),
            Separator()
        ],
      ),
    );
  }

  void initiateData()async{
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
      if(favorites == null){
        favorites = List();
      }else{
        favorites.clear();
      }
      for(int i = favorites.length; i < 8;i++){
        if(i == 7){
          favorites.add(PlaceModel.forOperator());
        }else{
          favorites.add(PlaceModel.emptyPlace(prefix: i.toString()));
        }
      }
      if(mounted){
        setState(() {
          viewState = 0;
        });
      }
    }
  }

  updateFavorites({List<PlaceModel> items}){
    if(mounted){
      setState(() {
        if(favorites == null){
          favorites = List();
        }else{
          favorites.clear();
        }
        favorites.addAll(items);
        print("before length : "+ favorites.length.toString());
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
        viewState = 0;
      });
    }
  }

  onDeletePlaceClicked(data){
    int idx = favorites.indexOf(data);
    if(idx >=0 && idx < favorites.length){
      if(mounted){
        setState(() {
          favorites[idx] = PlaceModel.emptyPlace(prefix: DateTime.now().millisecondsSinceEpoch.toString());
          savingToStore();
        });
      }
    }
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

  turnOnEditMode(){
    int diff = favorites.length - favorites.where((place) => place.id.startsWith(ConstantCollections.EMPTY_FAVORITE)).length;
    if(diff > 1){
      if(mounted){
        setState(() {
          isEditMode = true;
        });
      }
    }else{
      showModalBottomSheet(
        context: context,
        builder: (_) => ErrorModal(
          title: UserLanguage.of(context).errorTitle("favoriteIsEmpty"),
          desc: UserLanguage.of(context).errorDesc("favoriteIsEmpty"),
        )
      );
    }
  }

  turnOffEditMode(){
    if(mounted){
      setState(() {
        isEditMode = false;
      });
    }
  }

  showPlaceList(trigger) async{
    if(!isEditMode){
      widget.openingPlace();
      showBottomSheet(
        context: context,
        builder: (context){
          return PlacesListByCategoryModal(
            onSelected: onSelectedPlace,
            placeHolder: trigger,
          );
        }
      );
    }
  }

  onSelectedPlace(List<PlaceModel> item){
    if(item != null){
      if(favorites.where((place)=> place.forSearch == item[1].forSearch).length > 0){
        showModalBottomSheet(
          context: context,
          builder: (_) => ErrorModal(
            title: UserLanguage.of(context).errorTitle('placeIsAlreadyExist'),
            desc: UserLanguage.of(context).errorDesc('placeIsAlreadyExist')
          )
        );
      }else{
        int idx = favorites.indexOf(item[0]);
        if(mounted){
          setState(() {
            favorites[idx] = item[1];
            savingToStore();
            widget.closingPlace();
          });
        }
      }
    }
  }
}