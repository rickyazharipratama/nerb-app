import 'package:flutter/material.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/NerbApp.dart';

void main() async{

  //check language
  String lang = await PreferenceHelper.instance.getStringValue(key : ConstantCollections.PREF_LANGUAGE);
  if(lang == null){
    lang = ConstantCollections.LANGUAGE_EN;
    PreferenceHelper.instance.setStringValue(
      key: ConstantCollections.PREF_LANGUAGE,
      value: lang
    );
  }

  //check default radius
  int radius = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);
  if(radius < 0){
    PreferenceHelper.instance.setIntValue(
      key: ConstantCollections.PREF_RADIUS,
      value: ConstantCollections.DEFAULT_RADIUS
    );
  }
  
  runApp(NerbApp(language: lang));
}