import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/PresenterViews/LandingPageView.dart';
import 'package:nerb/Views/Modals/MinorUpdate.dart';
import 'BasePresenter.dart';

class LandingPagePresenter extends BasePresenter{
  LandingPageView _view;

  StreamController<bool> _categoryController = StreamController.broadcast();
  StreamController<int> _actionMenuController = StreamController.broadcast();

  StreamSink get categorySinker => _categoryController.sink;
  Stream get categoryStream => _categoryController.stream;

  StreamSink get amController => _actionMenuController.sink;
  Stream get amStream => _actionMenuController.stream;

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
    FirebaseAnalyticHelper.instance.setScreen(
      screen: "Landing Page"
    );
    decisionForMinorUpdate();
    CommonHelper.instance.settingSystemUi();
  }

  dispose(){
    _categoryController?.close();
    _actionMenuController.close();
  }
}