import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nerb/PresenterViews/Components/Buttons/ActionMenuButtonView.dart';
import 'package:nerb/Presenters/Components/Buttons/ActionMenuButtonPresenter.dart';

class ActionMenuButton extends StatefulWidget {

  final Stream<int> stream;

  ActionMenuButton({@required this.stream});

  @override
  _ActionMenuButtonState createState() => new _ActionMenuButtonState();
}

class _ActionMenuButtonState extends State<ActionMenuButton> with TickerProviderStateMixin,ActionMenuButtonView{

  ActionMenuButtonPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = ActionMenuButtonPresenter(widget.stream)..setView = this;
    setAnimationController = this;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: presenter.onWillPop,
      child: InkWell(
        onTap: presenter.onTapIcon,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
          ),
          child: Center(
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: anim,
              color: Color.lerp(Theme.of(context).buttonColor,Colors.red,anim.value),
              size: 25
            ),
          ),
        ),
      ),
    );
  }

  @override
  BuildContext currentContext() => context;

  @override
  notifyState(){
    if(mounted){
      setState(() {
        
      });
    }
  }
}