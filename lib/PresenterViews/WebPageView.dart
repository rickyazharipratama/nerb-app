import 'package:flutter/rendering.dart';

class WebPageView{

  Rect _rect;

  Rect get rect => _rect;
  set setRect(Rect rct){
    _rect = rct;
  }

  onRectChanged(Rect rct){
    if(_rect == null){
      setRect = rct;
    }else{
      if(_rect != rct){
        setRect = rct;
        requestResize();
      }
    }
  }

  requestResize(){

  }
}