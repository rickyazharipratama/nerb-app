import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Views/Pages/LandingPage.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  bool isNeedGetKey = false;
  bool isNeedGetCategory = false;
  bool isNeedGetPlaces = false;

  int hereApiVersion;
  int lastSavedCategoriesVersion;
  int lastSavedPlaceVersion;

  bool isError = false;
  RemoteConfig remoteConfig;
  bool isNeedLoading = true;

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children:<Widget>[
          Positioned.fill(
            child:Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Theme.of(context).brightness == Brightness.light ? "assets/nerb-black.png" : "assets/nerb-white.png",
                    width: 85,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Text(
                      UserLanguage.of(context).desc("splash"),
                      style: Theme.of(context).textTheme.body1
                    ),
                  )
                ],
              )
            ),
          ),
          isNeedLoading ?
            Positioned(
              bottom: 15 + MediaQuery.of(context).padding.bottom,
              right: 0,
              left: 0,
              child: Center(
                child: SpinKitThreeBounce(
                  color: Theme.of(context).buttonColor,
                  size: 20,
                ),
              ),
            )
          : Container()
        ]
      ) 
    );
  }

  initiateData() async{
    bool isMaintenance = await CommonHelper.instance.checkMaintenance(context);
    bool isMajorUpdate = await CommonHelper.instance.isMajorUpdateVersion(context);
    if(!isMaintenance){
      if(!isMajorUpdate){
        await openLAstAct();
      }
    }
  }

  openLAstAct() async{
    if(!isError){
      Location loc = Location();
      if(! await loc.hasPermission()){
        await loc.requestPermission();
      }
      if(await loc.hasPermission()){
        NerbNavigator.instance.newClearRoute(context,
          child: LandingPage()
        );   
      } 
    }
  }
}