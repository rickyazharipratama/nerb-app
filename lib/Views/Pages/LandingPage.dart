import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Views/Components/Collections/Categories.dart';
import 'package:nerb/Views/Components/Collections/Favorite.dart';
import 'package:nerb/Views/Components/Collections/PlacesNearYou.dart';
import 'package:nerb/Views/Modals/Settings.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin{

  AnimationController animController;
  Animation anim;
  bool isSettingActive = false;
  BuildContext parentContext;
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 700));
    anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      curve: Curves.easeIn,
      parent: animController
    ))..addListener((){
      if(mounted){
        setState(() {
          
        });
      }
    });
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
        actions: <Widget>[

          InkWell(
            onTap: (){
              if(isSettingActive){
                if(mounted){
                  closeSettingMenu();
                }
              }else{
                if(mounted){
                  setState(() {
                    isSettingActive = true;
                    animController.forward();
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
                  progress: anim,
                  color: Color.lerp(Theme.of(context).buttonColor,Colors.red,anim.value),
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
          parentContext = childContext;
          return ListView(
            children: <Widget>[
              Favorite(),
              Padding(padding: const EdgeInsets.all(5),),
              Categories(),
              PlacesNearYou()
            ],
          );
        }
      )
    );
  }
  
  showSettingMenu(){
    showBottomSheet(
      context: parentContext,
      builder: (context){
        return Settings();
      },
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  closeSettingMenu(){
    if(mounted){
      setState(() {
          isSettingActive = false;
          animController.reverse();
          Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }
}