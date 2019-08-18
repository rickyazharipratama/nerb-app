import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/Views/Components/Collections/Items/CategoryItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerCategories.dart';
import 'package:nerb/Views/Components/misc/WrapperError.dart';

class Categories extends StatefulWidget {

  Categories();
  @override
  _CategoriesState createState() => new _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  int viewState = 1;
  bool isError = false;
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

                isError ?
                  WrapperError(
                    height: 100,
                    buttonText: UserLanguage.of(context).button("retry"),
                    callback: (){
                      if(mounted){
                        setState(() {
                          isError = false;
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
    if(!isError){
      List<FirestoreCategory> tmpCategories = new List();
      List<String> prefCat = await PreferenceHelper.instance.getStringListValue(key: ConstantCollections.PREF_LAST_CATEGORY);
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
          viewState = 0;
        });
      }
    }
  }
}