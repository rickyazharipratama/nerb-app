import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Views/Components/Shimmers/Items/ShimmerItemPlaceNearYou.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlaceNearYou extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(width);
    return Container(
      height: 200,
      child: Shimmer.fromColors(
        baseColor: ColorCollections.shimmerBaseColor,
        highlightColor: ColorCollections.shimmerHighlightColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [1,2,3].map((_){
              return ShimmerItemPlaceNearYou(
              );
          }).toList(),
        ),
      ),
    );
  }
}