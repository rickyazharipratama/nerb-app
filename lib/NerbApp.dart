import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/Collections/translations/UserLanguageLocalizationDelegate.dart';
import 'package:nerb/Presenters/NerbAppPresenter.dart';
import 'package:nerb/Views/Pages/Splash.dart';

import 'PresenterViews/NerbAppView.dart';

class NerbApp extends StatefulWidget {

  final String language;
  final NerbAppPresenter presenter = NerbAppPresenter();
  NerbApp({@required this.language});

  @visibleForTesting
  NerbApp.visibleForTesting({this.language : ConstantCollections.LANGUAGE_EN});

  @override
  _NerbAppState createState() => new _NerbAppState();

  static _NerbAppState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_NerbAppState>());
}

class _NerbAppState extends State<NerbApp> with NerbAppView{

  @override
  void initState() {
    super.initState();
    widget.presenter.setView = this;
    widget.presenter.initiateData();
  }

  @override
  BuildContext currentContext(){
    return context;
  }

  @override
  notifyChange(){
    if(mounted){
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.presenter.ul != null ?
    MaterialApp(
      locale: widget.presenter.ul.locale,
      home: Splash(),
      localizationsDelegates: [
        widget.presenter.ul,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      theme: widget.presenter.isUsedDarkTheme ? turnOffTheLight(widget.presenter.setToDarkMode) : bringTheLight(widget.presenter.setToLightMode),
      supportedLocales: [
        const Locale(ConstantCollections.LANGUAGE_EN),
        const Locale(ConstantCollections.LANGUAGE_ID)
      ],
    ): Material(
      color: Colors.white,
    );
  }

  @override
  changingTheme(isDarkTHeme){
    CommonHelper.instance.showLog("change dark theme is "+isDarkTHeme.toString());
    FirebaseAnalyticHelper.instance.sendEvent(
      event: ConstantCollections.EVENT_USING_THEME,
      params: {
        "date": DateTime.now().toString(),
        "theme":isDarkTHeme ? "dark" : "light" 
      }
    );
    if(mounted){
      setState(() {
        widget.presenter.setUsedDarkTheme = isDarkTHeme;
      });
    }
  }

  @override
  onLocaleChanged(Locale lc){
    CommonHelper.instance.showLog("masuk disini");
    FirebaseAnalyticHelper.instance.sendEvent(
      event: ConstantCollections.EVENT_SELECT_LANGUAGE,
      params: {
        'date': DateTime.now().toString(),
        'language':lc.languageCode
      }
    );
    if(mounted){
      setState(() {
        widget.presenter.setUl = UserLanguageLocalizationDelegate(locale: lc);
      });
    }
  }
}