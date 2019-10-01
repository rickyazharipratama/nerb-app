import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nerb/Views/Modals/Settings.dart';

class LandingPageView{
    AnimationController _animController;
    Animation _anim;
    bool _isSettingActive = false;
    bool _isPlaceActive = false;
    BuildContext _context;
    bool _isCategoryRetrieve = false;

    AnimationController get animationController => _animController;
    Animation get animation => _anim;
    bool get isSettingActive => _isSettingActive;
    bool get isPlaceActive => _isPlaceActive;
    bool get isCategoryRetrieve => _isCategoryRetrieve;
    BuildContext get parentContext => _context;

    void setAnimation({@required AnimationController controller}){
      if(controller != null){
        _anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          curve: Curves.ease,
          parent: controller
        ))
        ..addListener(onAnimationListening);
      }else{
        debugPrint("animationController is null");
      }
    }
    void setAnimationController(TickerProvider tick){
      if(tick != null){
        _animController = AnimationController(
          vsync: tick,
          duration: const Duration(milliseconds: 700)
        );
      }else{
        debugPrint("ticker provider is missing");
      }
    }
    set setSettingActive(bool val){_isSettingActive = val;}
    set setPlaceActive(bool val){_isPlaceActive = val;}
    set setCategoryRetrieve(bool val){_isCategoryRetrieve = val;}
    set setContext(BuildContext ctx){_context = ctx;}


    void onAnimationListening(){}
    void onActionHasTapped(){}
    void openingPlaceList(){}
    void closingPlaceList(){}

    void showSettingMenu(){
      showBottomSheet(
        context: parentContext,
        builder: (context){
          return Settings();
        },
        backgroundColor: Colors.white,
        elevation: 0
      );
    }
    void closeSettingMenu(){}
}