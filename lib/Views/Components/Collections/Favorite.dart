import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/Views/Components/Collections/Items/AddFavoritesItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimerFavorite.dart';
import 'package:nerb/Views/Components/misc/Separator.dart';

import 'Items/PlaceItem.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => new _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  List<PlaceModel> favorites = new List();
  int viewState = 1;

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
              padding: const EdgeInsets.only(bottom: 2),
              child: SectionTitle.withText(
                value: "Most Recently Used"
              ),
            ),

            Separator(),

            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: viewState == 0 ? 
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: favorites.getRange(0, 4).map((fav){
                      if(fav.id == ConstantCollections.EMPTY_FAVORITE){
                        return AddFavoritesItem(
                          callback: showPlaceList,
                        );
                      }
                      return PlaceItem(
                        place: fav,
                        callback: (){},
                      );
                    }).toList(),
                  ),

                  Padding(padding: const EdgeInsets.only(top: 10),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: favorites.getRange(4, 8).map((fav){
                      
                      if(fav.id == ConstantCollections.EMPTY_FAVORITE){
                        return AddFavoritesItem(
                          callback: showPlaceList,
                        );
                      }
                      return PlaceItem(
                        place: fav,
                      );

                    }).toList(),
                  )
                ],
              )
              : ShimmerFavorite()
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
      Firestore.instance.collection(ConstantCollections.FIRESTORE_DEFAULT_FAVORITE).snapshots().listen((document){
        for(DocumentSnapshot doc in document.documents){
          print(doc.documentID);
          print(doc.data.toString());
          tmpFavorites.add(PlaceModel.fromFireStore(doc.documentID, doc.data));
        }
        List<String> toSaved = new List();
        for(PlaceModel fav in tmpFavorites){
          toSaved.add(json.encode(fav.getMap()));
        }
        PreferenceHelper.instance.setStringListValue(
          key: ConstantCollections.PREF_MY_FAVORITE,
          value: toSaved
        );
        updateFavorites(items: tmpFavorites);
      });
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
        if(favorites.length < 8){
          for(int i = favorites.length; i <=8;i++){
            favorites.add(PlaceModel.emptyPlace());
          }
        }
        viewState = 0;
      });
    }
  }

  showPlaceList(){

  }
}