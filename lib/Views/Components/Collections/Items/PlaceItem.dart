import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/PlaceModel.dart';

class PlaceItem extends StatelessWidget {

  final PlaceModel place;
  final ValueChanged callback;

  PlaceItem({this.place, this.callback});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        callback(place);
      },
      splashColor: ColorCollections.shimmerHighlightColor,
      highlightColor: ColorCollections.shimmerBaseColor,
      child: Container(
        width: 65,
        height: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: ColorCollections.baseGrayColor
                ),
                color: Colors.transparent,
              ),
              child: Center(
                child: Icon(
                  IconData(int.parse(place.materialIcon),fontFamily: "MaterialIcons"),
                  color: ColorCollections.titleColor,
                  size: 30,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                  left: 2,
                  right: 2
                ),
                child: Text(
                  UserLanguage.of(context).currentLanguage != ConstantCollections.LANGUAGE_ID ? place.name.id: place.name.en,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: ColorCollections.titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: FontSizeHelper.titleMenu(scale: MediaQuery.of(context).textScaleFactor),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

}