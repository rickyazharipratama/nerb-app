import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';

class ImagePlaceholder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.landscape,
        color: ColorCollections.shimmerHighlightColor,
        size: 30,
      ),
    );
  }
}