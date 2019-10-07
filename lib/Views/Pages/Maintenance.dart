import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/PresenterViews/MaintenanceView.dart';
import 'package:nerb/Presenters/MaintenancePresenter.dart';

class Maintenance extends StatefulWidget{
  
  @override
  MaintenanceState createState() => MaintenanceState();

}

class MaintenanceState extends State<Maintenance> with MaintenanceView{

  MaintenancePresenter presenter = MaintenancePresenter();
  Timer timer;
  RemoteConfig rc;
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
                color: getColorIcon(context),
                size: getIconSize(context)
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
                            UserLanguage.of(context).title("maintenance"),
                            style: Theme.of(context).primaryTextTheme.title,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          UserLanguage.of(context).desc("maintenance"),
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
    timer?.cancel();
    super.dispose();
  }
}