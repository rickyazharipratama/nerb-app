import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nerb/Views/Modals/Settings.dart';

class ActionMenuButtonView{

  // 0 hamburger icon
  // 1 close icon
  int _mode = 0;
  AnimationController _animationController;
  Animation _anim;

  AnimationController get animationController => _animationController;
  Animation<double> get anim => _anim;
  set setAnimationController(TickerProvider tick){
    _animationController = AnimationController(
      vsync: tick,
      duration: const Duration(milliseconds: 500)
    )..addListener(notifyState);
    _anim = Tween<double>(
      begin: 0,
      end: 1
    ).animate(CurvedAnimation(
      curve: Curves.ease,
      parent: _animationController
    ));
  }

  int get mode => _mode;
  set setMode(int val){
    _mode = val;
  }

  void notifyState(){}
  BuildContext currentContext(){
    return null;
  }

  void closeWidget({dynamic param}){
    Navigator.of(currentContext(), rootNavigator: true).pop(param);
  }

  void showSettingMenu(){
    showBottomSheet(
      context: currentContext(),
      builder: (context){
        return Settings();
      },
      backgroundColor: Colors.white,
      elevation: 0
    );
  }
}