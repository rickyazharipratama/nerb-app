import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/PresenterViews/LandingPageView.dart';
import 'package:nerb/Presenters/LandingPagePresenter.dart';
import 'package:nerb/Views/Components/Collections/Categories.dart';
import 'package:nerb/Views/Components/Collections/Favorite.dart';
import 'package:nerb/Views/Components/Collections/PlacesNearYou.dart';

class LandingPage extends StatefulWidget {
  

  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin, LandingPageView{

  LandingPagePresenter presenter = LandingPagePresenter();
  @override
  void initState() {
    super.initState();
    presenter.setView = this;
    setAnimationController(this);
    setAnimation(controller: animationController);
    presenter.initiateData();
  }
  
  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
            Theme.of(context).brightness == Brightness.dark ? 'assets/nerb-white.png' : 'assets/nerb-black.png',
            width: (30 * 16)/9,
            alignment: Alignment.topCenter,
            height: 30,
            color: Theme.of(context).brightness == Brightness.dark ? Color(0xfffefefe) : Color(0xff252525),
            colorBlendMode: BlendMode.dstIn,
            fit: BoxFit.contain,
          ),
        actions: <Widget>[

          InkWell(
            onTap: (){
              if(isSettingActive){
                if(mounted){
                  setState(() {
                      closeSettingMenu();
                  });
                }
              }else if(isPlaceActive){
                if(mounted){
                  setState(() {
                    closingPlaceList();
                  });
                }
              }else{
                if(mounted){
                  setState(() {
                    setSettingActive = true;
                    animationController.forward();
                    showSettingMenu();
                  });
                }
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
              ),
              child: Center(
                child: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: animation,
                  color: Color.lerp(Theme.of(context).buttonColor,Colors.red,animation.value),
                  size: 25,
                ),
              ),
            ),
          )

        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body:  Builder(
        builder: (childContext){
          setContext = childContext;
          return ListView(
            children: <Widget>[
              Favorite(
                closingPlace: closingPlaceList,
                openingPlace: openingPlaceList,
                isCategoryRetrieve: isCategoryRetrieve,
              ),
              Padding(padding: const EdgeInsets.all(5),),
              Categories(
                onDataRetrieved: (){
                  if(mounted){
                    setState(() {
                      setCategoryRetrieve = true;
                    });
                  }
                },
              ),
              PlacesNearYou()
            ],
          );
        }
      )
    );
  }
  
  @override
  openingPlaceList(){
    if(mounted){
      setState(() {
        setPlaceActive = true;
        animationController.forward();
      });
    }
  }

  @override
  closingPlaceList(){
    if(mounted){
      setState(() {
        setPlaceActive = false;
        animationController.reverse();
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }

  @override
  closeSettingMenu(){
    if(mounted){
      setState(() {
          setSettingActive = false;
          animationController.reverse();
          Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }

  @override
  void onAnimationListening() {
    super.onAnimationListening();
    if(mounted){
      setState(() {
        
      });
    }
  }
  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}