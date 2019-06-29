import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimerFavorite.dart';
import 'package:nerb/Views/Components/misc/Separator.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => new _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(bottom: 2),
             child: SectionTitle.withText(
               value: "Most Recently Used"
             ),
           ),

           Separator(),

           Padding(
             padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
             child: ShimmerFavorite()
           ),
           
           Separator()
        ],
      ),
    );
  }
}