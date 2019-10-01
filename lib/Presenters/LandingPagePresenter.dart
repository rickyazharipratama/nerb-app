import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/PresenterViews/LandingPageView.dart';
import 'package:nerb/Views/Modals/MinorUpdate.dart';
import 'BasePresenter.dart';

class LandingPagePresenter extends BasePresenter{
  LandingPageView _view;

  LandingPageView get view => _view;
  set setView(LandingPageView vw){_view = vw;}

  @override
  decisionForMinorUpdate() async{
    if(await isMinorUpdate()){
      await showModalBottomSheet(
        context: view.parentContext,
        builder: (context) => MinorUpdate()
      );
      deactivateMinorUpdate(view.parentContext);
    }
  }

  @override
  void initiateData() {
    super.initiateData();
    decisionForMinorUpdate();
    CommonHelper.instance.settingSystemUi();
  }
}