import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:shimmer/shimmer.dart';

import 'Items/ShimmerCategory.dart';

class ShimmerCategories extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: ColorCollections.shimmerBaseColor,
        highlightColor: ColorCollections.shimmerHighlightColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [0,1,2].map((_){
            return ShimmerCategory();
          }).toList(),
        )
      ),
    );
  }
}