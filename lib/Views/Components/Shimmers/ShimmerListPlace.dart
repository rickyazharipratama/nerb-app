import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Views/Components/Shimmers/Items/ShimmerPlace.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListPlace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Shimmer.fromColors(
        baseColor: ColorCollections.shimmerBaseColor,
        highlightColor: ColorCollections.shimmerHighlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [1].map((_){
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Container(
                    width: 200,
                    height: 20,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: ColorCollections.titleWhite,
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      ShimmerPlace(),
                      ShimmerPlace(),
                      ShimmerPlace(),
                      ShimmerPlace(),
                      ShimmerPlace()
                    ],
                  )
                ],
              )
            );
          }).toList(),
        ),
      ),
    );
  }
}