import 'package:flutter/material.dart';

class SettingView{

  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;
  set setDarkTheme(bool val){
    _isDarkTheme = val;
  }

  void notifyState(){}
  BuildContext currentContext(){
    return null;
  }

}