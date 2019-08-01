import 'package:flutter/material.dart';
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
      });
    }
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
      theme: isUsedDarkTheme ? NerbTheme.instance.darkTheme : NerbTheme.instance.lightTheme,
      darkTheme: NerbTheme.instance.darkTheme,
      supportedLocales: [
        const Locale(ConstantCollections.LANGUAGE_EN),
        const Locale(ConstantCollections.LANGUAGE_ID)
      ],
    ): Material(
      color: Colors.white,
    );
  }

  changingTheme(isDarkTHeme){
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