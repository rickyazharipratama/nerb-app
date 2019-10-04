import 'package:flutter/widgets.dart';

class EditPlaceItemView{
  AnimationController _animController;
  Animation _anim;

  AnimationController get animController => _animController;
  setAnimController(TickerProvider tick){
    _animController = AnimationController(vsync: tick, duration: const Duration(milliseconds: 120));
    _anim = Tween<double>(begin: -0.02, end: 0.02).animate(CurvedAnimation(
       parent: _animController,
       curve: Curves.easeIn,
      reverseCurve: Curves.easeOut
     ))..addListener(notifyState)
     ..addStatusListener((status){
       if(status == AnimationStatus.completed){
        _animController.reverse();
       }else if(status == AnimationStatus.dismissed){
        _animController.forward();
       }
     });
     _animController.forward();
  }

  Animation get anim => _anim;

  notifyState(){

  }

}