import 'package:flutter/widgets.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Views/Pages/LandingPage.dart';

class WrapperPermissionView{

  PageController _pageController;
  int _activeIndex = 0;

  PageController get pageController => _pageController;

  int get activeIndex => _activeIndex;
  set setActiveIndex(int idx){
    _activeIndex = idx;
  }

  initiatePageController(){
    _pageController = PageController(
      initialPage: activeIndex,
    );
  }

  goToLandingPage(){
    NerbNavigator.instance.newClearRoute(currentContext(),child: LandingPage());
  }

  BuildContext currentContext(){
    return null;
  }
}