import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGridPlaces extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).highlightColor,
        highlightColor: ColorCollections.shimmerHighlightColor,
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          childAspectRatio: 9/16,
          children: [1,2,3,4].map((_){
            return Container(
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              height: ((((MediaQuery.of(context).size.width - 25) / 2) * 16) / 9),
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