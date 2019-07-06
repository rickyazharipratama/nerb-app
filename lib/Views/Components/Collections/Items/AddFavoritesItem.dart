import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:dashed_container/dashed_container.dart';

class AddFavoritesItem extends StatelessWidget {

  final VoidCallback callback;
  AddFavoritesItem({this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      highlightColor: ColorCollections.shimmerHighlightColor,
      splashColor: ColorCollections.shimmerBaseColor,
      child: DashedContainer(
        borderRadius: 5,
        dashedLength: 5,
        strokeWidth: 2,
        dashColor: ColorCollections.baseGrayColor,
        child: SizedBox(
          height: 70,
          width: 60,
          child: Center(
            child: Icon(
              Icons.add_circle_outline,
              color: ColorCollections.baseGrayColor,
              size: 30,
            ),
          ),
        )
      ),
    );
  }
}