import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/PresenterViews/LandingPageView.dart';
import 'package:nerb/Presenters/LandingPagePresenter.dart';
import 'package:nerb/Views/Components/Buttons/ActionMenuButton.dart';
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
          ActionMenuButton(
            stream: presenter.amStream,
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
                categoryStream: presenter.categoryStream,
                amSinker: presenter.amController,
              ),
              Padding(padding: const EdgeInsets.all(5),),
              Categories(
                sinker: presenter.categorySinker,
              ),
              PlacesNearYou()
            ],
          );
        }
      )
    );
  }
  
  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }
}