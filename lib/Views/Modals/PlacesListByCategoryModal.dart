
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/Models/Names.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceItem.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerListPlace.dart';
import 'package:nerb/Views/Components/misc/Separator.dart';

class PlacesListByCategoryModal extends StatefulWidget {

  final ValueChanged<List<PlaceModel>> onSelected;
  final PlaceModel placeHolder;

  PlacesListByCategoryModal({@required this.onSelected, @required this.placeHolder});

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
              ) : ShimmerListPlace(),
            )
          ]
        ),
      ),
    );
  }
  
  initiateData() async{

    List<FirestoreCategory> tmpCategories = List();
    List<String> cat = await PreferenceHelper.instance.getStringListValue(
      key: ConstantCollections.PREF_LAST_CATEGORY
    );
    cat.forEach((ct){
      tmpCategories.add(FirestoreCategory(jsonDecode(ct)));
    });

    List<String> plcs = await PreferenceHelper.instance.getStringListValue(
      key: ConstantCollections.PREF_LAST_PLACE
    );
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
  }

  onTappedPlaceItem(item){
    List<PlaceModel>lst = List();
    lst.add(widget.placeHolder);
    lst.add(item);
    widget.onSelected(lst);
  }
}