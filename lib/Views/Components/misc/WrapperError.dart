import 'dart:ui';

import 'package:flutter/material.dart';

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
      color: Theme.of(context).canvasColor,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 7,
            sigmaY: 7,
          ),
          child: Center(
            child: Container(
              height: height,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              color: Theme.of(context).dialogBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Text(
                    this.title,
                    style: Theme.of(context).primaryTextTheme.display1
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 10
                      ),
                      child: Text(
                        this.desc,
                        style: Theme.of(context).primaryTextTheme.display2
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
                          color: Theme.of(context).buttonColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          this.buttonText,
                          style: Theme.of(context).primaryTextTheme.display2
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