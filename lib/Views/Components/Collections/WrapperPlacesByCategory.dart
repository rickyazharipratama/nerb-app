import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Names.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceItem.dart';
import 'package:nerb/Views/Components/Shimmers/Items/ShimmerPlace.dart';
import 'package:nerb/Views/Components/misc/ErrorPlaceholder.dart';
import 'package:nerb/Views/Pages/Places.dart';
import 'package:shimmer/shimmer.dart';

class WrapperPlacesBycategory extends StatefulWidget {

  final String category;

  WrapperPlacesBycategory({this.category});

  @override
  _WrapperPlacesBycategoryState createState() => new _WrapperPlacesBycategoryState();
}

class _WrapperPlacesBycategoryState extends State<WrapperPlacesBycategory> implements RequestResponseCallback{

  // 0 main
  // 1 load
  // 2 error
  int viewState = 1;
  bool isAlreadyRetry = false;
  int statusCode = 500;

  List<PlaceModel> places;
  List<Names> sections;
  bool isNeedUpdate = false;
  int currPlaceVersion =-1;
  @override
  void initState() {
    super.initState();
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return viewState == 0 ?
      places.length > 0 ?
        ListView(
          children: sections.map((sct){
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? sct.id : sct.en,
                      style: Theme.of(context).primaryTextTheme.subhead,
                    ),
                  ),

                  Wrap(
                    spacing: 10,
                    runSpacing: 15,
                    children: places.where((plc) => plc.section.id == sct.id && plc.section.en == sct.en).map((place){
                      return PlaceItem(
                        place: place,
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
              ),
            );
          }).toList(),
        )
      : ErrorPlaceholder(
          title: UserLanguage.of(context).errorTitle("typePlaceEmpty"),
          desc: UserLanguage.of(context).errorDesc("typePlaceEmpty"),
          isNeedButton: false,
      )
    : viewState == 2 ? ErrorPlaceholder(
      title: UserLanguage.of(context).errorTitle("general"),
      desc: UserLanguage.of(context).errorDesc("general"),
      buttonText: UserLanguage.of(context).button("retry"),
      callback: (){
        viewState = 1;
        initiateData();
      },
    ) : Shimmer.fromColors(
          baseColor: Theme.of(context).highlightColor,
          highlightColor: ColorCollections.shimmerHighlightColor,
          child : Wrap(
            runSpacing: 15,
            spacing: 10,
            children: [0,1,2,3,4,5].map((data){
              return ShimmerPlace();
            }).toList(),
          )
      );
  }

  initiateData() async{
    RemoteConfig rc = await CommonHelper.instance.fetchRemoteConfig();
    int lastPlacesVersion = await PreferenceHelper.instance.getIntValue(
      key: ConstantCollections.PREF_LAST_PLACE_VERSION
    );
    if(lastPlacesVersion > 0){
       currPlaceVersion = rc.getInt(ConstantCollections.REMOTE_CONFIG_PLACES_VERSION);
       if(lastPlacesVersion < currPlaceVersion){
          isNeedUpdate = true;
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
        if(mounted){
          setState((){
            if(places == null){
              places = List();
            }else{
              places.clear();
            }
            places.addAll(tmpPlace.where((pm)=> pm.categories.contains(widget.category)).toList());
            places.sort((a,b) => UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? a.section.id.compareTo(b.section.id) : a.section.en.compareTo(b.section.en));

            if(sections == null){
              sections = List();
            }else{
              sections.clear();
            }
            sections.add(places[0].section);
            places.forEach((plc){
              if(sections.where((sct) => (sct.id == plc.section.id && sct.en == plc.section.en)).toList().length == 0){
                  sections.add(plc.section);
              }
            });
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
  onSuccessResponseFailed(Map<String,dynamic> data) {
    if(data['statusCode'] == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyRetry){
        isAlreadyRetry = true;
        initiateData();
      }else{
        if(mounted){
          setState(() {
            viewState = 2;
            statusCode = data['statusCode'];
          });
        }
      }
    }else{
      if(mounted){
          setState(() {
            viewState = 2;
            statusCode = data['statusCode'];
          });
        }
    }
  }

  @override
  onSuccessResponseSuccess(Map<String,dynamic> data) {
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

    strTmp.forEach((st){
      places.add(PlaceModel.fromStore(jsonDecode(st)));
    });
    places.sort((a,b) => UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? a.section.id.compareTo(b.section.id) : a.section.en.compareTo(b.section.en));
    if(sections == null){
      sections = List();
    }else{
      sections.clear();
    }
    sections.add(places[0].section);
    places.forEach((plc){
      if(sections.where((sct) => (sct.id == plc.section.id && sct.en == plc.section.en)).toList().length == 0){
        sections.add(plc.section);
      }
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
        viewState = 2;
        statusCode = 500;
      });
    }
  }
}