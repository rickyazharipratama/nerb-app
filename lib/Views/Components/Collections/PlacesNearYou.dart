import 'package:flutter/material.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerPlaceNearYou.dart';

class PlacesNearYou extends StatefulWidget {
  @override
  _PlacesNearYouState createState() => new _PlacesNearYouState();
}

class _PlacesNearYouState extends State<PlacesNearYou> {

  int viewState = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 2, right: 10),
            child: SectionTitle.withText(
              value: "Places Near You"
            ),
          ),

          viewState == 1?
            ShimmerPlaceNearYou()
          :Container()
        ],
      ),
    );
  }

}