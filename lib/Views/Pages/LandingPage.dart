import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Views/Components/Collections/Categories.dart';
import 'package:nerb/Views/Components/Collections/Favorite.dart';
import 'package:nerb/Views/Components/Collections/PlacesNearYou.dart';
import 'package:nerb/Views/Components/Shimmers/ShimerFavorite.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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