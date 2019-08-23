import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Views/Pages/LandingPage.dart';
import 'package:nerb/Views/Pages/WrapperPermission.dart';

class NoLocationServices extends StatefulWidget {

  @override
  _NoLocationServicesState createState() => new _NoLocationServicesState();

}

class _NoLocationServicesState extends State<NoLocationServices> {

  Timer timer;

  @override
  void initState() {
    super.initState();
    initiateData();
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

  initiateData() async{
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async{
       print("location service");
       if(await LocationPermissions().checkServiceStatus() == ServiceStatus.enabled){
         if(await LocationPermissions().checkPermissionStatus() == PermissionStatus.granted){
           NerbNavigator.instance.newClearRoute(context,
              child: LandingPage()
           );
         }else{
           NerbNavigator.instance.newClearRoute(context,
            child: WrapperPermission()
           );
         }
       }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}