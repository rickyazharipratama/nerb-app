import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class UserLanguage{
  Locale _locale;
  Map<dynamic,dynamic> _localizedValue;

  Locale get locale => _locale;

  String get currentLanguage => locale.languageCode;

  localizedValue(Map<dynamic,dynamic> localized){
    if(_localizedValue == null){
      _localizedValue = Map();
    }else{
      _localizedValue.clear();
    }
    _localizedValue.addAll(localized);
  }

  String title(key){
    return _localizedValue['title'][key];
  }

  String desc(key){
    return _localizedValue['desc'][key];
  }

  String label(key){
    return _localizedValue['label'][key];
  }

  String button(key){
    return _localizedValue['button'][key];
  }

  String errorTitle(key){
    return _localizedValue['errorTitle'][key];
  }

  String errorDesc(key){
    return _localizedValue['errorDesc'][key];
  }

  UserLanguage(Locale locale){
    _locale = locale;
  }
  static UserLanguage of(context) => Localizations.of<UserLanguage>(context, UserLanguage);

  static Future<UserLanguage> load(Locale locale) async{
    UserLanguage ul = UserLanguage(locale);
    String jsonContent = await rootBundle.loadString("assets/lang/i18n_"+ul._locale.languageCode+".json");
    ul.localizedValue(jsonDecode(jsonContent));
    return ul;
  }
}