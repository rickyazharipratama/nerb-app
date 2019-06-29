import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';

class ShimmerItemPlaceNearYou extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        color: ColorCollections.bgPrimary,
        borderRadius: BorderRadius.circular(5)
      ),
    );
  }

}