import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Views/Components/Collections/Categories.dart';
import 'package:nerb/Views/Components/Collections/Favorite.dart';
import 'package:nerb/Views/Components/Collections/PlacesNearYou.dart';
import 'package:nerb/Views/Modals/Settings.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin{

  String language = "en";
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
    initiateData();
  }

  initiateData() async{
    String tmpLang = await PreferenceHelper.instance.getStringValue(key: ConstantCollections.PREF_LANGUAGE);
    if(tmpLang == null){
      tmpLang = language;
      PreferenceHelper.instance.setStringValue(
        key: ConstantCollections.PREF_LANGUAGE,
        value: tmpLang
      );
    }
    if(mounted){
      setState(() {
        language = tmpLang;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
                  color: Color.lerp(ColorCollections.titleColor,Colors.red,anim.value),
                  size: 25,
                ),
              ),
            ),
          )

        ],
      ),
      backgroundColor: ColorCollections.bgPrimary,
      body:  Builder(
        builder: (childContext){
          parentContext = childContext;
          return ListView(
            children: <Widget>[
              Favorite(
                language: language,
              ),
              Padding(padding: const EdgeInsets.all(5),),
              Categories(
                language: language,
              ),
              PlacesNearYou(
                language: language,
              )
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
        return Settings(
          language: language,
        );
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