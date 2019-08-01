import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
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

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  initiateData() async{
    String lang = await PreferenceHelper.instance.getStringValue(key: ConstantCollections.PREF_LANGUAGE);
    if(mounted){
      setState(() {
        ulDelegate = UserLanguageLocalizationDelegate(locale: Locale(lang));
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
      supportedLocales: [
        const Locale(ConstantCollections.LANGUAGE_EN),
        const Locale(ConstantCollections.LANGUAGE_ID)
      ],
    ): Material(
      color: Colors.white,
    );
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