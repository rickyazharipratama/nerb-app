import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListPlaces extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).highlightColor,
        highlightColor: ColorCollections.shimmerHighlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [1,2,3].map((_){
            return Container(
              height: ((MediaQuery.of(context).size.width - 20) * 9 / 16 ) +80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}