import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
import 'package:nerb/Models/PlaceModel.dart';

class PlaceItem extends StatelessWidget {

  final PlaceModel place;

  PlaceItem({this.place});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: ColorCollections.shimmerBaseColor,
            ),
            child: Center(
              child: Icon(
                IconData(int.parse(place.materialIcon),fontFamily: "MaterialIcons"),
                color: ColorCollections.shimmerHighlightColor,
                size: 30,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              place.name.en,
              style: TextStyle(
                color: ColorCollections.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: FontSizeHelper.titleList(scale: MediaQuery.of(context).textScaleFactor),
              ),
            ),
          )
        ],
      ),
    );
  }

}