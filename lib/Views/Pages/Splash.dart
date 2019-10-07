import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/PresenterViews/SplashView.dart';
import 'package:nerb/Presenters/SplashPresenter.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> with SplashView{

  SplashPresenter presenter = SplashPresenter();
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
}