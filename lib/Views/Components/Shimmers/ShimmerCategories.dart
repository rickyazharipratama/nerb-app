import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Views/Components/Shimmers/Items/ShimmerDynamicBox.dart';
import 'package:shimmer/shimmer.dart';

import 'Items/ShimmerCategory.dart';

class ShimmerCategories extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return  Container(
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).highlightColor,
          highlightColor: ColorCollections.shimmerHighlightColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [0,1,2].map((_){
              double defWidth = 200;
              double marginRight = 10;
              if(width > 0){
                 if(width < defWidth+ 20){
                   defWidth = width - 20;
                   marginRight = 10;
                   width = 0;
                 }else{
                   defWidth -= (defWidth+20);
                 }
              }else{
                width = -1;
              }
              if(width > 0){
               return  ShimmerCategory(
                  width: defWidth,
                  marginRight: marginRight,
                  
                );
              }else{
                if(width == 0){
                  return Expanded(
                    child: ShimmerDynamicBox(
                      height: 113,
                      marginleft: 10,
                      marginRight: 0,
                    ),
                  );
                }
                return Expanded(child: Container(),);
              }
            }).toList(),
          )
      ),
    );
  }
}