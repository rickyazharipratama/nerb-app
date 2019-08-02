import 'package:flutter/material.dart';
import 'package:nerb/Routers/NoTransitionRoute.dart';

class NerbNavigator{

static NerbNavigator instance = NerbNavigator();

  newClearRoute(BuildContext context, {Widget child}){
    Navigator.of(context).pushAndRemoveUntil(NoTransitionRoute(
      builder: (context)=> child,
      duration: const Duration(milliseconds: 700), 
    ), (Route route) => route == null);
  }

  Future<dynamic> push(BuildContext context, {Widget child}){
      return Navigator.of(context).push(PageRouteBuilder(
        barrierColor:Color(0x77000000),
        pageBuilder: (context,_,__)=> child,
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context,anim,__,child){
          return FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              curve: Curves.easeOut,
              parent: anim
            )),
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0,0.075), end: Offset(0,0)).animate(CurvedAnimation(
                curve: Curves.easeOut,
                parent: anim
              )),
              child: child,
            ),
          );
        }
      ));
  }
}