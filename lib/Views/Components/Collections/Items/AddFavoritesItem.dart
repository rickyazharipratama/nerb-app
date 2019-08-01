import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:dashed_container/dashed_container.dart';
import 'package:nerb/Models/PlaceModel.dart';

class AddFavoritesItem extends StatelessWidget {

  final ValueChanged callback;
  final PlaceModel place;
  AddFavoritesItem({this.callback, this.place});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        callback(place);
      },
      highlightColor: ColorCollections.shimmerBaseColor,
      splashColor: ColorCollections.shimmerHighlightColor,
      child: DashedContainer(
        borderRadius: 5,
        dashedLength: 5,
        strokeWidth: 2,
        dashColor: Theme.of(context).buttonColor,
        child: SizedBox(
          height: 80,
          width: 65,
          child: Center(
            child: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).buttonColor,
              size: 30,
            ),
          ),
        )
      ),
    );
  }
}