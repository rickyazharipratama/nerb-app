import 'dart:async';

import 'package:nerb/PresenterViews/Components/Buttons/ActionMenuButtonView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class ActionMenuButtonPresenter extends BaseComponentPresenter{

  ActionMenuButtonView _view;
  final Stream<int> stream;

  ActionMenuButtonPresenter(this.stream){
      stream.listen(onListenStream);
  }

  ActionMenuButtonView get view => _view;
  set setView(ActionMenuButtonView vw){
    _view = vw;
  }

  @override
  void initiateData() {
    super.initiateData();
  }

  void onTapIcon(){
    if(view.mode == 0){
      view.showSettingMenu();
      view.setMode = 1;
      view.animationController.forward();
    }else{
      view.closeWidget();
      view.setMode = 0;
      view.animationController.reverse();
    }
  }

  Future<bool> onWillPop() async{
    if(view.mode != 0 ){
      view.closeWidget();
      view.setMode = 0;
      view.animationController.reverse();
    }
    return false;
  }

  onListenStream(int val){
    if(view.mode != val){
      view.setMode = val;
      if(val == 0){
        view.closeWidget();
        view.animationController.reverse();
      }else{
        view.animationController.forward();
      }
    }
  }
}