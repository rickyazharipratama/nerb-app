import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';

class ErrorModal extends StatelessWidget {

  final String title;
  final String desc;

  ErrorModal({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10,5,10,10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: <Widget>[
                 Expanded(child: Container()),
                 InkWell(
                   onTap: (){
                     Navigator.of(context, rootNavigator: true).pop();
                   },
                   splashColor: ColorCollections.shimmerHighlightColor,
                   highlightColor: ColorCollections.shimmerBaseColor,
                   borderRadius: BorderRadius.circular(12.5),
                   child:  Center(
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: Colors.red,
                    ),
                   ),
                 )
               ],
             ),

             Text(
              this.title,
              style: TextStyle(
              color: Colors.red,
              fontSize: FontSizeHelper.titleSectionSize(scale: MediaQuery.of(context).textScaleFactor),
              fontWeight: FontWeight.w500
              ),
             ),

             Padding(
               padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
               child: Text(
                 this.desc,
                 style: TextStyle(
                   color: ColorCollections.titleColor,
                   fontSize: FontSizeHelper.titleMenu(scale: MediaQuery.of(context).textScaleFactor),
                   fontWeight: FontWeight.w700
                 ),
               ),
             )
          ],
        ),
      ),
    );
  }
}