import 'dart:ui';
import 'package:flutter/material.dart';

class NerbPushAppBar extends StatelessWidget {

  final String title;
  final VoidCallback action;

  NerbPushAppBar({@required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return  ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding:  EdgeInsets.fromLTRB(10,MediaQuery.of(context).padding.top + 7,0,10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).primaryTextTheme.title,
                ),
              ),

              InkWell(
                borderRadius: BorderRadius.circular(25),
                highlightColor: Theme.of(context).highlightColor,
                onTap: action == null ?(){
                  Navigator.of(context).pop();
                } : action,
                child:Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).buttonColor,
                    size: 25,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}