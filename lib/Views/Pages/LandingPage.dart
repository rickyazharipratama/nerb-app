import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Views/Components/Collections/Categories.dart';
import 'package:nerb/Views/Components/Collections/Favorite.dart';
import 'package:nerb/Views/Components/Collections/PlacesNearYou.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 5
          ),
          child: Center(
            child: Hero(
              tag: "nerbeeLogo",
              child: Text("NERBEE"),
            ),
          ),
        )
      ),
      backgroundColor: ColorCollections.bgPrimary,
      body: ListView(
        children: <Widget>[
          Favorite(),
          Padding(padding: const EdgeInsets.all(5),),
          Categories(),
          PlacesNearYou()
        ],
      ),
    );
  }

}