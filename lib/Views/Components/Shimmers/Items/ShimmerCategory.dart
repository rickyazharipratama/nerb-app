import 'package:flutter/material.dart';

class ShimmerCategory extends StatelessWidget {
  
  final double width;
  final double marginRight;

  ShimmerCategory({this.width, this.marginRight});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10 , right: 10),
      width: 200,
      height: 113,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
    );
  }
}