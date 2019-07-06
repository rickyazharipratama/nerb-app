import 'package:flutter/widgets.dart';
import 'package:nerb/Routers/NoTransitionRoute.dart';

class NerbNavigator{

static NerbNavigator instance = NerbNavigator();

  newClearRoute(BuildContext context, {Widget child}){
    Navigator.of(context).pushAndRemoveUntil(NoTransitionRoute(
      builder: (context)=> child,
      duration: const Duration(milliseconds: 700), 
    ), (Route route) => route == null);
  }
}