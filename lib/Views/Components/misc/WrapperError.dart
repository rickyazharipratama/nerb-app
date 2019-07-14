import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';

class WrapperError extends StatelessWidget {
  final String title;
  final String desc;
  final String buttonText;
  final double height;
  final VoidCallback callback;

  WrapperError({
    @required this.title,
    @required this.desc,
    @required this.buttonText,
    @required this.height,
    @required this.callback
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorCollections.wrapCategoryIcon,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              color: ColorCollections.wrapperCategory,
              height: this.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Text(
                    this.title,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: FontSizeHelper.titleList(scale: MediaQuery.of(context).textScaleFactor),
                      fontWeight: FontWeight.w500
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 10
                      ),
                      child: Text(
                        this.desc,
                        style: TextStyle(
                          color: ColorCollections.titleWhite,
                          fontWeight: FontWeight.w300,
                          fontSize: FontSizeHelper.titleMenu(scale: MediaQuery.of(context).textScaleFactor)
                        ),
                      ),
                    ),
                  ),
                                                      
                  Center(
                    child: InkWell(
                      onTap: callback,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                        decoration: BoxDecoration(
                          color: ColorCollections.titleColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          this.buttonText,
                          style: TextStyle(
                            color: ColorCollections.titleWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: FontSizeHelper.titleMenu(scale : MediaQuery.of(context).textScaleFactor),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}