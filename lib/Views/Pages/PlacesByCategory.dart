import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbTheme.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/PresenterViews/PlaceByCategoryView.dart';
import 'package:nerb/Presenters/PlaceByCategoryPresenter.dart';
import 'package:nerb/Views/Components/Collections/WrapperPlacesByCategory.dart';

class PlacesByCategory extends StatefulWidget {

  final String imageUrl;
  final FirestoreCategory category;
  final PlaceByCategoryPresenter presenter = PlaceByCategoryPresenter();

  PlacesByCategory({@required this.imageUrl, @required this.category});

  @override
  _PlacesByCategoryState createState() => new _PlacesByCategoryState();
}

class _PlacesByCategoryState extends State<PlacesByCategory> with PlaceByCategoryView{

  @override
  void initState() {
    super.initState();
    widget.presenter.setView = this;
    setImage = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
        return false;
      },
      child: Material(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: <Widget>[
                  
                  Positioned.fill(
                    child: Hero(
                      tag: widget.category.id,
                      child: Image.asset(
                        widget.imageUrl,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        color: ColorCollections.wrapperCategory,
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.srcATop,
                      )
                    )
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Hero(
                            tag: "icon-"+widget.category.id,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: ColorCollections.wrapCategoryIcon,
                                borderRadius: BorderRadius.circular(25)
                              ),
                              child: Center(
                                child: widget.category.icon != null ?
                                    Icon(
                                      IconData(int.parse(widget.category.icon),fontFamily: 'MaterialIcons'),
                                      size: 25,
                                      color: ColorCollections.titleColor,
                                    )
                                    : Icon(
                                      Icons.landscape,
                                      size: 25,
                                      color: ColorCollections.titleColor,
                                    ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Hero(
                                tag: "title-"+widget.category.id,
                                child: Text(
                                  UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? widget.category.name.id : widget.category.name.en,
                                  style: Theme.of(context).textTheme.title,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Positioned(
              top: (MediaQuery.of(context).size.height /2),
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Theme.of(context).backgroundColor,
                      offset: Offset(0,-5),
                      spreadRadius: 5
                    ),
                    BoxShadow(
                      blurRadius: 10,
                      color: Theme.of(context).brightness == Brightness.dark ? NerbTheme.instance.backDarkGradient[1] : NerbTheme.instance.backLightGradient[1],
                      offset: Offset(0,-15),
                      spreadRadius: 5
                    ),
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: WrapperPlacesBycategory(
                    category: widget.category.id,
                  ),
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons. close,
                  color: Colors.red,
                  size: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}