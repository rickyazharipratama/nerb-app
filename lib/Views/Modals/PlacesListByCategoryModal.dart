import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/Models/Names.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceItem.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerListPlace.dart';
import 'package:nerb/Views/Components/misc/Separator.dart';

class PlacesListByCategoryModal extends StatefulWidget {
  PlacesListByCategoryModal();

  @override
  _PlacesListByCategoryModalState createState() => new _PlacesListByCategoryModalState();
}

class _PlacesListByCategoryModalState extends State<PlacesListByCategoryModal> {


  List<FirestoreCategory> categories;
  List<PlaceModel> places;

  int viewState = 1;
  bool isLoadError = false;

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Material(
        color: Theme.of(context).backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children : <Widget>[

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(
                    UserLanguage.of(context).label('places'),
                    style: Theme.of(context).primaryTextTheme.title
                  ),),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            Separator(),

            Expanded(
              child:  viewState == 0 ? ListView(
                children: categories.map((item){
                  List<PlaceModel> plcs = List();
                  plcs.addAll(places.where((plc)=> plc.categories.contains(item.id)));
                  print(plcs.length);
                  List<Names> sections;
                  
                  if(plcs != null){
                    if(plcs.length > 0){
                      if(plcs.length > 1){
                        plcs.sort((a,b){
                          return UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? a.section.id.compareTo(b.section.id) : a.section.en.compareTo(b.section.en);
                        });
                      }
                      sections = List();
                      Names lastSection = plcs[0].section;
                      sections.add(lastSection);
                      for(int i=1;i <plcs.length;i++){
                        Names curr = plcs[i].section;
                        if(lastSection.en != curr.en && lastSection.id != curr.id){
                          sections.add(curr);
                          lastSection = curr;
                        }
                      }
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 5),
                          child: Text(
                            UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? item.name.id : item.name.en,
                            style: Theme.of(context).primaryTextTheme.subtitle
                          )
                        ),

                        sections != null ?
                          sections.length > 0 ?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: sections.map((plc){
                                List<PlaceModel> sctPlace = plcs.where((pc) => pc.section.id == plc.id && pc.section.en == plc.en).toList();
                                print("sctPlace : "+sctPlace.length.toString());
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10,bottom: 5),
                                      child: Text(
                                        UserLanguage.of(context).locale.languageCode == ConstantCollections.LANGUAGE_ID ? plc.id: plc.en,
                                        style: Theme.of(context).primaryTextTheme.subtitle
                                      )
                                    ),
                                    sctPlace != null ?
                                      sctPlace.length > 0 ?
                                        Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.start,
                                          runSpacing: 15,
                                          spacing: 10,
                                          children: sctPlace.map((pct){
                                            return PlaceItem(
                                              callback: onTappedPlaceItem,
                                              place: pct,
                                            );
                                          }).toList(),
                                        )
                                      : Container()
                                    : Container()
                                  ],
                                );
                              }).toList(),
                            )
                          : Container()
                        :Container()
                      ],
                    ),
                  );
                }).toList(),
              ) : ShimmerListPlace(),
            )
          ]
        ),
      ),
    );
  }
  
  initiateData(){
    Firestore.instance.collection(ConstantCollections.FIRESTORE_CATEGORY)
      .snapshots()
      .listen(retrieveCategory)
      .onError(onLoadError);
  }

  retrieveCategory(QuerySnapshot data){
    if(!isLoadError){
      List<FirestoreCategory> tmpCategories = List();
        for(DocumentSnapshot doc in data.documents){
          tmpCategories.add(FirestoreCategory(doc.documentID, doc.data));
        }
        if(categories == null){
          categories = List<FirestoreCategory>();
        } else{
          categories.clear();
        }
        categories.addAll(tmpCategories);
        if(places != null){

          if(mounted){
            setState(() {
              print("places : "+places.length.toString());
              viewState = 0;
            });
          }
        }
      Firestore.instance.collection(ConstantCollections.FIRESTORE_PLACE)
        .snapshots()
        .listen(retrievePlace)
        .onError(onLoadError);
    }
  }

  retrievePlace(QuerySnapshot data){
    if(!isLoadError){
      List<PlaceModel> tmp = List();
      for(DocumentSnapshot doc in data.documents){
        tmp.add(PlaceModel.fromFireStore(doc.documentID,doc.data));
      }
      if(places == null){
        places = List();
      }else{
        places.clear();
      }
      places.addAll(tmp);
      if(categories != null){
        if(mounted){
          setState(() {
            viewState = 0;
          });
        }
      }
    }
  }

  onLoadError(error){
    if(mounted){
      setState(() {
        viewState = 1;
        isLoadError = true;
      });
    }
  }

  onTappedPlaceItem(item){
    Navigator.of(context, rootNavigator: true).pop(item);  
  }
}