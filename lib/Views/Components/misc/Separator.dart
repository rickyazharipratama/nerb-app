import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';

class Separator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 2,
      color: ColorCollections.shimmerBaseColor,
    );
  }
}