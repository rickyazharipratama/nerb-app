import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
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
  bool isLoadError = false;
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
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: nearbyPlace.nearbyPlaces.map((place){
                  return PlaceNearYouItem(
                    place: place,
                  );
                }).toList(),
              ),
            )
          : Container(
            height: 200,
            child: Stack(
              children: <Widget>[

                Positioned.fill(
                  child: ShimmerPlaceNearYou(),
                ),

                isLoadError ?
                  Material(
                    color: ColorCollections.wrapCategoryIcon,
                    child: ClipRect(
                    child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 3,
                      sigmaY: 3
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: ColorCollections.wrapperCategory,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  Text(
                                    "Ups..!",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: FontSizeHelper.titleList(scale: MediaQuery.of(context).textScaleFactor),
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),

                                  Expanded(
                                    child: Text("Ipsum dolor amet ipsum dolor amet ipsum dolor amet",
                                      style: TextStyle(
                                        color: ColorCollections.titleWhite,
                                        fontWeight: FontWeight.w300,
                                        fontSize: FontSizeHelper.titleMenu(scale: MediaQuery.of(context).textScaleFactor)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding : const EdgeInsets.only(left: 5, right: 10),
                              child: InkWell(
                                onTap: (){
                                  if(mounted){
                                    setState(() {
                                      isLoadError = false;
                                      initiateData();
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ColorCollections.titleColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "Retry",
                                    style: TextStyle(
                                      color: ColorCollections.titleWhite,
                                      fontWeight: FontWeight.w700,
                                      fontSize: FontSizeHelper.titleMenu(scale : MediaQuery.of(context).textScaleFactor),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                  )
                  )
                : Container()

              ],
            ),
          )
        ],
      ),
    );
  }


  initiateData() async{
    Location loc = Location();
    LocationData  dt = await loc.getLocation();
    
    PlaceController.instance.getNearbyPlace(
      callback: this,
      location: dt.latitude.toString()+","+dt.longitude.toString(),
      radius: "800"
    );
  }

  @override
  onFailureWithResponse(Response res) {
    return null;
  }

  @override
  onSuccessResponseFailed(Map<String,dynamic> data) {
    if(mounted){
      setState((){
        isLoadError = true;
      });
    }
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