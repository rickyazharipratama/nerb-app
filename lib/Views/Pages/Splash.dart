import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Views/Pages/LandingPage.dart';
import 'package:location/location.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Hero(
          tag: "nerbeeLogo",
          child: Text("NERBEE"),
        ),
      ),
    );
  }

  initiateData(){
    Timer(const Duration(milliseconds: 500),() async{

      Location loc = Location();
      if(! await loc.hasPermission()){
        await loc.requestPermission();
      }
      if(await loc.hasPermission()){
        NerbNavigator.instance.newClearRoute(context,
          child: LandingPage()
        );
      }
      
    });
  }

}