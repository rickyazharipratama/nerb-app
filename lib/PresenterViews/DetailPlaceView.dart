import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:nerb/Callbacks/ViewCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';

class DetailPlaceView implements ViewCallback{

  AnimationController _animationController;
  Animation _anim;
  double _offset = 0;
  double _currentOffsetPercent = 0;
  bool _isDetailExpanded = false;
  String _img;
  int _viewState = 1;
  
  AnimationController get animationController => _animationController;
  Animation get anim => _anim;
  double get offset => _offset;
  double get currentOffsetPercent => _currentOffsetPercent;
  bool get isDetailExpanded => _isDetailExpanded;
  String get img => _img;
  int get viewState => _viewState;

  setAnimationController(TickerProvider tick, Duration duration){
    if(tick != null){
      _animationController = AnimationController(
        vsync: tick,
        duration: duration
      );
    }else{
      CommonHelper.instance.showLog("Ticker provider is missing");
    }
  }

  setAnimation(BuildContext context, {bool isOpen : false}){
    if(animationController != null){
      _anim = Tween<double>(begin: offset, end: isOpen? (MediaQuery.of(context).size.height - 100) - 35 : 0)
      .animate(CurvedAnimation(
        curve: Curves.ease,
        parent: animationController
      ))
      ..addStatusListener((status){
        if(status == AnimationStatus.completed){
          setDetailExpanded = isOpen;
        }
      })
      ..addListener(onAnimationListening);
    }else{
      CommonHelper.instance.showLog("animation controller is null");
    }
  }

  set setDetailExpanded(bool val){
    _isDetailExpanded = val;
  }

  set setOffset(double val){
    _offset = val;
  }

  set setCurrentOffsetPercent(double val){
    _currentOffsetPercent = val;
  }

  set setImg(String image){
    _img = image;
  }

  set setViewState(int val){
    _viewState = val;
  }

  animationExplorer(BuildContext context,{@required bool isOpen, @required TickerProvider tick}){
    setAnimationController(tick, Duration(milliseconds: 1+(500 * (isDetailExpanded ? currentOffsetPercent : (1 - currentOffsetPercent))).toInt()));
    if(anim != null){
      _anim = null;
    }
    setAnimation(context, isOpen: isOpen);
    animationController.forward();
  }

  void onAnimationListening(){}

  BuildContext getCurrentContext(){return null;}

  @override
  void onError() {

  }

  @override
  void onSuccess() {
  }
}