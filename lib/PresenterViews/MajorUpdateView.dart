import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:store_redirect/store_redirect.dart';

class MajorUpdateView{

  Color getIconColor(){
    return Theme.of(currentContext()).brightness == Brightness.dark ? ColorCollections.titleColor : ColorCollections.shimmerBaseColor;
  }

  double getIconSize(){
    return MediaQuery.of(currentContext()).size.width * 3 / 4;
  }

  BuildContext currentContext(){
    return null;
  }

  goToMarket(){
    StoreRedirect.redirect(
      androidAppId: "com.teamCoret.nerb",
    );
  }
}