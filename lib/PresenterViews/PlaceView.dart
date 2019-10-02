import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nerb/Callbacks/ViewCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Views/Modals/ErrorModal.dart';

class PlaceView implements ViewCallback{

  //0 list
  //1 gridview
  int _mode = 0;

  int _viewState = 1;

  ScrollController _scrollController;


  int get mode => _mode;
  int get viewState => _viewState;
  ScrollController get scrollController => _scrollController;

  set setMode(int md){_mode = md;}
  set setViewState(int state){_viewState = state;}
  set setScrollController(VoidCallback callback){
    _scrollController = ScrollController(debugLabel: "place scroll label")..addListener(callback);
  }

  Color getIconColor(){
    return Theme.of(currentContext()).brightness == Brightness.light ? mode == 0 ? Colors.white : Theme.of(currentContext()).primaryTextTheme.body1.color : mode == 0 ? Color(0xff585858) :Theme.of(currentContext()).primaryTextTheme.body1.color;
  }

  bool isEndOfBottomScroll(){
    return scrollController.offset >= scrollController.position.maxScrollExtent && ! scrollController.position.outOfRange;
  }

  BuildContext currentContext(){
    return null;
  }

  showErrorBottomModal(int statusCode){
    showModalBottomSheet(
      context: currentContext(),
      builder: (context)=>ErrorModal(
        title: CommonHelper.instance.getTitleErrorByCode(context: currentContext(), code: statusCode),
        desc: CommonHelper.instance.getDescErrorByCode(context: currentContext(), code: statusCode),
      )
    );
  }

  void onEndScrolling(){

  }

  @override
  void onError() {
  }

  @override
  void onSuccess() {
  }

}