import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/PresenterViews/NoLocationServiceView.dart';
import 'package:nerb/Presenters/NoLocationServicePresenter.dart';

class NoLocationServices extends StatefulWidget {
  @override
  _NoLocationServicesState createState() => new _NoLocationServicesState();

}

class _NoLocationServicesState extends State<NoLocationServices> with NoLocationServiceView{

  Timer timer;
  NoLocationServicePresenter presenter = NoLocationServicePresenter();
  @override
  void initState() {
    super.initState();
    presenter.setView = this;
    presenter.initiateData();
  }

  @override
  BuildContext currentContext() {
    return context;
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: <Widget>[

          Positioned.fill(
            child: Center(
              child: Icon(
                Icons.location_off,
                color: getIconColor(),
                size: getIconSize(),
              ),
            ),
          ),

          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                            UserLanguage.of(context).title("locationService"),
                            style: Theme.of(context).primaryTextTheme.title,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          UserLanguage.of(context).desc("locationService"),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).primaryTextTheme.body1,
                        ),
                      )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}