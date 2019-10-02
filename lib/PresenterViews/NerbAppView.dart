import 'package:flutter/material.dart';
import 'package:nerb/Collections/NerbTheme.dart';

class NerbAppView{

  ThemeData bringTheLight(VoidCallback light){
    light();
    return NerbTheme.instance.lightTheme;
  }

  ThemeData turnOffTheLight(VoidCallback dark){
    dark();
    return NerbTheme.instance.darkTheme;
  }

  BuildContext currentContext(){
    return null;
  }

  void changingTheme(bool isDark){}

  void onLocaleChanged(Locale lc){}

  void notifyChange(){

  }

}