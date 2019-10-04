import 'package:flutter/cupertino.dart';

class DetailPlaceItemView{
  
  double getHeight(double mode){
    return mode == 0 ? ((MediaQuery.of(currentContext()).size.width - 20) * 9) / 16 : (((MediaQuery.of(currentContext()).size.width - 25)/2)*16)/9;
  }

  double getWidth(double mode){
    return mode == 0 ? MediaQuery.of(currentContext()).size.width - 20 : (MediaQuery.of(currentContext()).size.width - 25) / 2;
  }

  BuildContext currentContext() => null;
}