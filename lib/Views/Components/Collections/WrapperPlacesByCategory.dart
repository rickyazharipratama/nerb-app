import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
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

class _WrapperPlacesBycategoryState extends State<WrapperPlacesBycategory> {

  // 0 main
  // 1 load
  // 2 error
  int viewState = 1;

  List<PlaceModel> places;
  List<Names> sections;

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
    List<String> plcs = await PreferenceHelper.instance.getStringListValue(
      key: ConstantCollections.PREF_LAST_PLACE
    );
    print("source place: "+plcs.length.toString());
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
  }
}