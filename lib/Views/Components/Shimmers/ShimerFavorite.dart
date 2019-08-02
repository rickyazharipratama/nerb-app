import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Views/Components/Shimmers/Items/ShimmerPlace.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerFavorite extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Shimmer.fromColors(
        highlightColor: ColorCollections.shimmerHighlightColor,
        baseColor: Theme.of(context).highlightColor,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ShimmerPlace(),
                ShimmerPlace(),
                ShimmerPlace(),
                ShimmerPlace()
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ShimmerPlace(),
                ShimmerPlace(),
                ShimmerPlace(),
                ShimmerPlace(),
              ],
            )
          ],
        )
      ),
    );
  }
}