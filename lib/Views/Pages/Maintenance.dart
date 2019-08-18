import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Views/Pages/Splash.dart';

class Maintenance extends StatefulWidget{

  @override
  MaintenanceState createState() => MaintenanceState();

}

class MaintenanceState extends State<Maintenance>{

  Timer timer;
  RemoteConfig rc;
  @override
  void initState() {
    super.initState();
    initiateData();
  }

  initiateData()async{
    rc = await CommonHelper.instance.fetchRemoteConfig();
    timer = Timer.periodic(const Duration(minutes: 3),(timer) async{
       rc = await CommonHelper.instance.fetchRemoteConfig();
       bool isMaintenance = rc.getBool(ConstantCollections.REMOTE_CONFIG_IS_MAINTENANCE);
       print("timer running");
       if(!isMaintenance){
         print("navigate to splash");
         NerbNavigator.instance.newClearRoute(context,
            child: Splash()
         );
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: <Widget>[

          Positioned.fill(
            child: Center(
              child: Icon(
                Icons.location_off,
                color: Theme.of(context).brightness == Brightness.dark ? ColorCollections.titleColor : ColorCollections.shimmerBaseColor,
                size: MediaQuery.of(context).size.width * 3 /  4,
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
}