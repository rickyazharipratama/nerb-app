import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/PresenterViews/Components/Collections/CategoriesView.dart';
import 'package:nerb/Presenters/Components/Collections/CategoriesPresenter.dart';
import 'package:nerb/Views/Components/Collections/Items/CategoryItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerCategories.dart';
import 'package:nerb/Views/Components/misc/WrapperError.dart';

class Categories extends StatefulWidget {
  final StreamSink sinker;

  Categories({@required this.sinker});
  @override
  _CategoriesState createState() => new _CategoriesState();
}

class _CategoriesState extends State<Categories> with CategoriesView{
  CategoriesPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = CategoriesPresenter(widget.sinker)..setView = this;
    presenter.initiateData();
  }

  @override
  Widget build(BuildContext context) {
    if(presenter.categories != null){
      CommonHelper.instance.showLog("categories length : "+presenter.categories.length.toString());
    }else{
      CommonHelper.instance.showLog("Categories is null");
    }
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
                children: presenter.categories.map((category){
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
                          setViewState = 1;
                          presenter.initiateData();
                        });
                      }
                    },
                    title: CommonHelper.instance.getTitleErrorByCode(
                      code: presenter.statusCode,
                      context: context
                    ),
                    desc: CommonHelper.instance.getDescErrorByCode(
                      code: presenter.statusCode,
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
  
  @override
  BuildContext currentContext() => context;
  
  @override
  onSuccess(){
    super.onSuccess();
    if(mounted){
      setState(() {
        setViewState = 0;
      });
    }
  }

  @override
  onError(){
    super.onError();
    if(mounted){
      setState(() {
        setViewState = 2;
      });
    }
  }
}