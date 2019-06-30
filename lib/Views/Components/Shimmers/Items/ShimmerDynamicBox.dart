import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';

class ShimmerDynamicBox extends StatelessWidget {

  final double height;
  final double marginRight;
  final double marginleft;

  ShimmerDynamicBox({this.height, this.marginleft,this.marginRight});
  
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin:  EdgeInsets.only(left: marginleft, right: marginRight),
      height: height,
      decoration: BoxDecoration(
        color: ColorCollections.bgPrimary,
        borderRadius: BorderRadius.circular(5)
      ),
    );
  }
}