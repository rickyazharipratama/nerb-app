import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';

class ShimmerItemPlaceNearYou extends StatelessWidget {

  final double width;
  final double marginRight;

  ShimmerItemPlaceNearYou({this.width : 150, this.marginRight : 10});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin:  EdgeInsets.only(left: 10, right: marginRight),
      width: width,
      height: 200,
      decoration: BoxDecoration(
        color: ColorCollections.bgPrimary,
        borderRadius: BorderRadius.circular(5)
      ),
    );
  }

}