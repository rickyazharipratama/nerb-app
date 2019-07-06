import 'package:flutter/material.dart';

class NoTransitionRoute extends MaterialPageRoute{
  final Duration duration;
  NoTransitionRoute({
    this.duration : const Duration(milliseconds: 500),
    WidgetBuilder builder,
    RouteSettings setting
  }) : super(builder : builder, settings :setting);

  @override
  Duration get transitionDuration => duration;
}