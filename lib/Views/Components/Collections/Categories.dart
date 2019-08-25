import 'dart:async';
import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/Views/Components/Collections/Items/CategoryItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerCategories.dart';
import 'package:nerb/Views/Components/misc/WrapperError.dart';

class Categories extends StatefulWidget {
  final VoidCallback onDataRetrieved;
  Categories({@required this.onDataRetrieved});
  @override
  _CategoriesState createState() => new _CategoriesState();
}

class _CategoriesState extends State<Categories> implements RequestResponseCallback{

  int viewState = 1;
  int statusCode = 500;
  bool isAlreadyRetry = false;
  bool isNeedUpdate = false;
  int currCategoryVersion = -1;
  List<FirestoreCategory> categories;

  @override
  void initState() {
    super.initState();
    initializationData();
  }
    
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          
          Padding(
            padding: const EdgeInsets.only(bottom: 7, left: 10, right: 10),
            child: SectionTitle.withText(
              value: UserLanguage.of(context).title("categories")
            ),
          ),

          viewState == 0?
            Container(
              height: 115,
              child:  ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((category){
                  return CategoryItem(
                    category: category
                  );
                }).toList(),
              ),
            )
          : Container(
            height: 115,
            child: Stack(
              children: <Widget>[

                Positioned.fill(
                  child: ShimmerCategories(),
                ),

                viewState == 2 ?
                  WrapperError(
                    height: 100,
                    buttonText: UserLanguage.of(context).button("retry"),
                    callback: (){
                      if(mounted){
                        setState(() {
                          viewState = 1;
                          onRetrieveCategory();
                        });
                      }
                    },
                    title: CommonHelper.instance.getTitleErrorByCode(
                      code: 500,
                      context: context
                    ),
                    desc: CommonHelper.instance.getDescErrorByCode(
                      code: 500,
                      context: context
                    ),
                  )
                :Container()
              ],
            ),
          )
        ],
      ),
    );
  }
    
  initializationData() async{
    await onRetrieveCategory(); 
  }

  onRetrieveCategory() async{
    RemoteConfig rc = await CommonHelper.instance.fetchRemoteConfig();
    int lastCategoryVersion = await PreferenceHelper.instance.getIntValue(
      key: ConstantCollections.PREF_LAST_CATEGORY_VERSION
    );
    if(lastCategoryVersion > 0){
      currCategoryVersion = rc.getInt(ConstantCollections.REMOTE_CONFIG_CATEGORY_VERSION);
      if(lastCategoryVersion < currCategoryVersion){
        isNeedUpdate = true;
      }
    }
    if(!isNeedUpdate){
      List<String> prefCat = await PreferenceHelper.instance.getStringListValue(key: ConstantCollections.PREF_LAST_CATEGORY);
      if(prefCat.length > 0){
        List<FirestoreCategory> tmpCategories = new List();
        prefCat.forEach((cat){
          tmpCategories.add(FirestoreCategory(jsonDecode(cat)));
        });
        if(mounted){
          setState(() {
            if(categories == null){
              categories = List<FirestoreCategory>();
            } else{
              categories.clear();
            }
            categories.addAll(tmpCategories);
            categories.sort((a,b)=> UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? a.name.id.compareTo(b.name.id) : a.name.en.compareTo(b.name.en));
            widget.onDataRetrieved();
            viewState = 0;
          });
        }
      }else{
        PlaceController.instance.getCategories(
          callback: this,
          lang: UserLanguage.of(context).currentLanguage
        );
      }
    }else{
      PlaceController.instance.getCategories(
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
        Timer(const Duration(seconds: 2),(){
          isAlreadyRetry = true;
          onRetrieveCategory();
        });
      }else{
        if(mounted){
          setState(() {
            statusCode = data['statusCode'];
            viewState = 2;
          });
        }
      }
    }else{
      if(mounted){
        setState(() {
          statusCode = data['statisCode'];
          viewState = 2;
        });
      }
    }
  }

  @override
  onSuccessResponseSuccess(Map<String, dynamic> data) {
    List<String> tmp = List();
    for(Map<String,dynamic> dt in data['result'] as List<dynamic>){
      tmp.add(jsonEncode(dt));
    }
    PreferenceHelper.instance.setStringListValue(
      key: ConstantCollections.PREF_LAST_CATEGORY,
      value: tmp
    );
    if(categories != null){
      categories.clear();
    }else{
      categories = List();
    }
    tmp.forEach((tp){
      categories.add(FirestoreCategory(jsonDecode(tp)));
    });
    if(mounted){
      setState(() {
        categories.sort((a,b)=> UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? a.name.id.compareTo(b.name.id) : a.name.en.compareTo(b.name.en));
        widget.onDataRetrieved();
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