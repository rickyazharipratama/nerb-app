import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguageLocalizationDelegate.dart';
import 'package:nerb/PresenterViews/NerbAppView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class NerbAppPresenter extends BasePresenter{

  NerbAppView _view;
  UserLanguageLocalizationDelegate _ul;
  bool _isUsedDarktheme = false;

  NerbAppView get view => _view;
  set setView(NerbAppView vw){
    _view = vw;
  }

  UserLanguageLocalizationDelegate get  ul => _ul;
  set setUl(UserLanguageLocalizationDelegate ul){
    _ul = ul;
  }

  bool get isUsedDarkTheme => _isUsedDarktheme;
  set setUsedDarkTheme(bool val){
    _isUsedDarktheme = val;
  }


  @override
  initiateData() async{
    String lang = await PreferenceHelper.instance.getStringValue(key: ConstantCollections.PREF_LANGUAGE);
    bool theme = await PreferenceHelper.instance.isHaveVal(key: ConstantCollections.PREF_IS_DARK_THEME);
    setUl = UserLanguageLocalizationDelegate(locale: Locale(lang));
    setUsedDarkTheme = theme;
    view.notifyChange();
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

  setToLightMode(){
    PreferenceHelper.instance.setBoolValue(key: ConstantCollections.PREF_IS_DARK_THEME, val: false);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Color(0x55000000),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xfffefefe),
      systemNavigationBarIconBrightness: Brightness.dark
    ));
  }

  setToDarkMode(){
    PreferenceHelper.instance.setBoolValue(key: ConstantCollections.PREF_IS_DARK_THEME, val: true);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Color(0x00000000),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xff252525),
      systemNavigationBarIconBrightness: Brightness.light
    ));
  }

}