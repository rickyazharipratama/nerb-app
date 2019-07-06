import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
import 'package:nerb/Models/PlaceModel.dart';

class PlaceItem extends StatelessWidget {

  final PlaceModel place;
  final VoidCallback callback;

  PlaceItem({this.place, this.callback});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      splashColor: ColorCollections.shimmerHighlightColor,
      highlightColor: ColorCollections.shimmerBaseColor,
      child: Container(
        width: 60,
        height: 80,
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

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                place.name.en,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: ColorCollections.titleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: FontSizeHelper.titleMenu(scale: MediaQuery.of(context).textScaleFactor),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

}