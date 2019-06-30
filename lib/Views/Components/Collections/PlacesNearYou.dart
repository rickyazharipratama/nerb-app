import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Response/NearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceNearYouItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerPlaceNearYou.dart';

class PlacesNearYou extends StatefulWidget {
  @override
  _PlacesNearYouState createState() => new _PlacesNearYouState();
}

class _PlacesNearYouState extends State<PlacesNearYou> implements RequestResponseCallback {

  int viewState = 1;

  NearbyPlaceResponse nearbyPlace;

  @override
  void initState() {
    super.initState();
    initiateData();
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

          viewState == 0?
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: nearbyPlace.nearbyPlaces.map((place){
                  return PlaceNearYouItem(
                    place: place,
                  );
                }).toList(),
              ),
            )
          :ShimmerPlaceNearYou()
        ],
      ),
    );
  }


  initiateData(){
    PlaceController.instance.getNearbyPlace(
      callback: this,
      location: "-6.300641,106.814095",
      radius: "800"
    );
  }

  @override
  onFailureWithResponse(Response res) {
    return null;
  }

  @override
  onSuccessResponseFailed(Map<String,dynamic> data) {
    return null;
  }

  @override
  onSuccessResponseSuccess(Map<String,dynamic> data) {
    print("masuk sini");
    nearbyPlace = NearbyPlaceResponse.fromJson(data);
    if(mounted){
      setState(() {
        viewState = 0;
      });
    }
  }

  @override
  onfailure() {
    print("error");
    return null;
  }

}