import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/Views/Components/Collections/Items/CategoryItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerCategories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => new _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  int viewState = 1;
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
                padding: const EdgeInsets.only(bottom: 2, left: 10, right: 10),
                child: SectionTitle.withText(
                  value: "Categories"
                ),
              ),
    
              viewState == 0?
                Container(
                  height: 115,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories.map((category){
                      print("called");
                      return CategoryItem(
                        category: category
                      );
                    }).toList(),
                  )
                )
              : ShimmerCategories()
    
            ],
          ),
        );
      }
    
      void initializationData() {
        Firestore.instance.collection(ConstantCollections.FIRESTORE_CATEGORY).snapshots().listen(onRetrieveCategory);
      }

      onRetrieveCategory(QuerySnapshot data){
        List<FirestoreCategory> tmpCategories = new List();
        for(DocumentSnapshot doc in data.documents){
          print(doc.documentID);
          print(doc.data.toString());
          tmpCategories.add(FirestoreCategory(doc.documentID, doc.data));
        }
        if(mounted){
          setState(() {
            if(categories == null){
              categories = List<FirestoreCategory>();
            } else{
              categories.clear();
            }
            categories.addAll(tmpCategories);
            viewState = 0;
          });
        }
      }
}