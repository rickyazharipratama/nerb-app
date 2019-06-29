import 'package:flutter/material.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerCategories.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => new _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  int viewState = 1;

  @override
  void initState() {
    super.initState();
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

          viewState == 1?
            ShimmerCategories()
          : Container()

        ],
      ),
    );
  }
}