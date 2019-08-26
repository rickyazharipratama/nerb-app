
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/Models/Names.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceItem.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerListPlace.dart';
import 'package:nerb/Views/Components/misc/ErrorPlaceholder.dart';
import 'package:nerb/Views/Components/misc/Separator.dart';

class PlacesListByCategoryModal extends StatefulWidget {

  final ValueChanged<List<PlaceModel>> onSelected;
  final PlaceModel placeHolder;

  PlacesListByCategoryModal({@required this.onSelected, @required this.placeHolder});

  @override
  _PlacesListByCategoryModalState createState() => new _PlacesListByCategoryModalState();
}

class _PlacesListByCategoryModalState extends State<PlacesListByCategoryModal> implements RequestResponseCallback{


  List<FirestoreCategory> categories;
  List<PlaceModel> places;

  int viewState = 1;
  bool isAlreadyRetry = false;
  int statusCode = 500;
  int currPlaceVersion = -1;
  bool isNeedUpdate = false;

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
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
              child: Text(
                UserLanguage.of(context).label('choosePlace'),
                softWrap: true,
                maxLines: 1,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).primaryTextTheme.title
              ),
            ),

            Expanded(
              child:  viewState == 0 ? ListView(
                children: categories.map((item){
                  List<PlaceModel> plcs = List();
                  plcs.addAll(places.where((plc)=> plc.categories.contains(item.id)));
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
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? item.name.id : item.name.en,
                            style: Theme.of(context).primaryTextTheme.subtitle
                          )
                        ),
                        Separator(),
                        sections != null ?
                          sections.length > 0 ?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: sections.map((plc){
                                List<PlaceModel> sctPlace = plcs.where((pc) => pc.section.id == plc.id && pc.section.en == plc.en).toList();
                                print("sctPlace : "+sctPlace.length.toString());
                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10,bottom: 5),
                                        child: Text(
                                          UserLanguage.of(context).locale.languageCode == ConstantCollections.LANGUAGE_ID ? plc.id: plc.en,
                                          style: Theme.of(context).primaryTextTheme.subhead
                                        )
                                      ),
                                      sctPlace != null ?
                                        sctPlace.length > 0 ?
                                          Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.start,
                                            runSpacing: 15,
                                            spacing: 5,
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
                                  ),
                              );
                              }).toList(),
                            )
                          : Container()
                        :Container(),
                        Separator()
                      ],
                    ),
                  );
                }).toList(),
              ) : Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: ShimmerListPlace(),
                  ),
                  viewState == 2 ?
                    Positioned.fill(
                      child: ErrorPlaceholder(
                        desc: CommonHelper.instance.getTitleErrorByCode(
                          code: statusCode,
                          context: context
                        ),
                        title: CommonHelper.instance.getDescErrorByCode(
                          code: statusCode,
                          context: context
                        ),
                        buttonText: UserLanguage.of(context).button("retry"),
                        callback: (){
                          if(mounted){
                            setState(() {
                              viewState = 1;
                              initiateData();
                            });
                          }
                        },
                      )
                    )
                  : Container()
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
  
  initiateData() async{
    RemoteConfig rc = await CommonHelper.instance.fetchRemoteConfig();
    int lastPlacesVersion = await PreferenceHelper.instance.getIntValue(
      key: ConstantCollections.PREF_LAST_PLACE_VERSION
    );
    if(lastPlacesVersion > 0){
      currPlaceVersion = rc.getInt(ConstantCollections.REMOTE_CONFIG_PLACES_VERSION);
      if(lastPlacesVersion  < currPlaceVersion){
        isNeedUpdate = true;
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
        if(mounted){
          setState(() {
            if(categories == null){
              categories = List();
            }else{
              categories.clear();
            }

            if(places == null){
              places = List();
            }else{
              places.clear();
            }

            categories.addAll(tmpCategories);
            places.addAll(tmpPlace);
            viewState = 0;
          });
        }
      }else{
        PlaceController.instance.getPlacesCategory(
          callback: this,
          lang: UserLanguage.of(context).currentLanguage
        );
      }
    }else{
      PlaceController.instance.getPlacesCategory(
        callback: this,
        lang: UserLanguage.of(context).currentLanguage
      );
    }
  }

  onTappedPlaceItem(item){
    List<PlaceModel>lst = List();
    lst.add(widget.placeHolder);
    lst.add(item);
    widget.onSelected(lst);
  }

  @override
  onFailureWithResponse(Response res) {
    if(mounted){
      setState(() {
        statusCode = res.statusCode;
        viewState = 2;
      });
    }
  }

  @override
  onSuccessResponseFailed(Response res) {
    if(res.statusCode == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyRetry){
        isAlreadyRetry = true;
        initiateData();
      }else{
        if(mounted){
          setState(() {
            statusCode = res.statusCode;
            viewState = 2;
          });
        }
      }
    }else{
       if(mounted){
         setState(() {
           statusCode = res.statusCode;
           viewState = 2;
         });
       }
    }
  }

  @override
  onSuccessResponseSuccess(Map<String,dynamic> data) async{
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

    if(places == null){
      places = List();
    }else{
      places.clear();
    }

    List<String> cat = await PreferenceHelper.instance.getStringListValue(
      key: ConstantCollections.PREF_LAST_CATEGORY
    );

    if(categories == null){
      categories = List();
    }else{
      categories.clear();
    }

    cat.forEach((ct){
      categories.add(FirestoreCategory(jsonDecode(ct)));
    });

    strTmp.forEach((st){
      places.add(PlaceModel.fromStore(jsonDecode(st)));
    });
    if(mounted){
      setState(() {
        viewState = 0;
      });
    }
  }

  @override
  onfailure() {
    if(mounted){
      setState(() {
        statusCode = 500;
        viewState = 2;
      });
    }
  }
}