import 'package:flutter/cupertino.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';

class BasePresenter{

  Future<bool> isMinorUpdate() async{
    return await PreferenceHelper.instance.isHaveVal(
      key: ConstantCollections.PREF_IS_MINOR_UPDATE
    );
  } 

  Future<bool> isMaintenance(BuildContext context) async{
    return await CommonHelper.instance.checkMaintenance(context);
  }

  activateMinorUpdate(BuildContext context){
    PreferenceHelper.instance.setBoolValue(
      key: ConstantCollections.PREF_IS_MINOR_UPDATE,
      val: true
    );
  }

  deactivateMinorUpdate(BuildContext context){
    PreferenceHelper.instance.setBoolValue(
      key: ConstantCollections.PREF_IS_MINOR_UPDATE,
      val: false
    );
  }

  void decisionForMinorUpdate(){}

  void initiateData(){}
}