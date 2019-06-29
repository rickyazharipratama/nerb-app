import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';

class SectionTitle extends StatelessWidget {

  final String value;
  SectionTitle.withText({this.value}) : assert(value != null);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: ColorCollections.titleColor,
        fontSize: FontSizeHelper.titleSectionSize(scale: MediaQuery.of(context).textScaleFactor),
        fontWeight: FontWeight.w500
      ),
    );
  }
}