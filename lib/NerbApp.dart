import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbTheme.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguageLocalizationDelegate.dart';
import 'package:nerb/Views/Pages/Splash.dart';

class NerbApp extends StatefulWidget {

  final String language;
  NerbApp({@required this.language});

  @visibleForTesting
  NerbApp.visibleForTesting({this.language : ConstantCollections.LANGUAGE_EN});

  @override
  _NerbAppState createState() => new _NerbAppState();

  static _NerbAppState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_NerbAppState>());
}

class _NerbAppState extends State<NerbApp> {

  UserLanguageLocalizationDelegate ulDelegate;
  bool isUsedDarkTheme = false;

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  initiateData() async{
    String lang = await PreferenceHelper.instance.getStringValue(key: ConstantCollections.PREF_LANGUAGE);
    bool theme = await PreferenceHelper.instance.isHaveVal(key: ConstantCollections.PREF_IS_DARK_THEME);
    if(mounted){
      setState(() {
        ulDelegate = UserLanguageLocalizationDelegate(locale: Locale(lang));
        isUsedDarkTheme = theme;
        setStyleStatusAndNavigation();
      });
    }
  }

  setStyleStatusAndNavigation(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: isUsedDarkTheme ? Brightness.dark : Brightness.light,
      statusBarColor: isUsedDarkTheme ? Colors.transparent : Color(0x55000000),
      statusBarIconBrightness: isUsedDarkTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isUsedDarkTheme ? Color(0xff252525) : Color(0xfffefefe),
      systemNavigationBarIconBrightness: isUsedDarkTheme? Brightness.light : Brightness.dark
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ulDelegate != null ?
    MaterialApp(
      locale: ulDelegate.locale,
      home: Splash(),
      localizationsDelegates: [
        ulDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      theme: isUsedDarkTheme ? toDarkMode() : toLightMode(),
      supportedLocales: [
        const Locale(ConstantCollections.LANGUAGE_EN),
        const Locale(ConstantCollections.LANGUAGE_ID)
      ],
    ): Material(
      color: Colors.white,
    );
  }

  ThemeData toLightMode(){
    isUsedDarkTheme = false;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xfffefefe),
      systemNavigationBarIconBrightness: Brightness.dark
    ));
    return NerbTheme.instance.lightTheme;
  }

  ThemeData toDarkMode(){
    isUsedDarkTheme = true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Color(0x55000000),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xff252525),
      systemNavigationBarIconBrightness: Brightness.light
    ));
    return NerbTheme.instance.darkTheme;
  }

  changingTheme(isDarkTHeme){
    print("theme is dark : "+isDarkTHeme.toString());
    PreferenceHelper.instance.setBoolValue(key: ConstantCollections.PREF_IS_DARK_THEME, val: isDarkTHeme);
    if(mounted){
      setState(() {
        isUsedDarkTheme = isDarkTHeme;
      });
    }
  }

  onLocaleChanged(Locale lc){
    print("masuk disini");
    if(mounted){
      setState(() {
        ulDelegate = UserLanguageLocalizationDelegate(locale: lc);
      });
    }
  }
}