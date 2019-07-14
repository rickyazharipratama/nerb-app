import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FontSizeHelper.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/StringHelper.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Response/NearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceNearYouItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerPlaceNearYou.dart';
import 'package:nerb/Views/Components/misc/WrapperError.dart';

class PlacesNearYou extends StatefulWidget {

  final String language;
  PlacesNearYou({this.language}): assert(language != null);

  @override
  _PlacesNearYouState createState() => new _PlacesNearYouState();
}

class _PlacesNearYouState extends State<PlacesNearYou> implements RequestResponseCallback {

  int viewState = 1;
  bool isLoadError = false;
  NearbyPlaceResponse nearbyPlace;

  String errorTitle;
  String errorDesc;

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
                value: StringHelper.instance.getCollections[widget.language]['titlePlacesNearYou']
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
                  WrapperError(
                    buttonText: StringHelper.instance.getCollections[widget.language]['btnRetry'],
                    title: errorTitle,
                    desc: errorDesc,
                    height: 120,
                    callback: (){
                      if(mounted){
                        setState(() {
                          isLoadError = false;
                          initiateData();
                        });
                      }
                    },
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
    int radius = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);
    PlaceController.instance.getNearbyPlace(
      callback: this,
      location: dt.latitude.toString()+","+dt.longitude.toString(),
      language: widget.language,
      radius: radius.toString()
    );
  }

  @override
  onFailureWithResponse(Response res) {
    if(mounted){
      setState(() {
        isLoadError = true;
        errorTitle = CommonHelper.instance.getTitleErrorByCode(
          code: res.statusCode,
          lang: widget.language
        );
        errorDesc = CommonHelper.instance.getDescErrorByCode(
          code: res.statusCode,
          lang: widget.language
        );
      });
    }
  }

  @override
  onSuccessResponseFailed(Map<String,dynamic> data) {
    if(mounted){
      setState((){
        isLoadError = true;
        errorTitle = CommonHelper.instance.getTitleErrorByStatus(
          lang: widget.language,
          status: data['status']
        );
        errorDesc = CommonHelper.instance.getDescErrorByStatus(
          lang: widget.language,
          status: data['status']
        );
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
    if(mounted){
      setState(() {
        isLoadError = true;
        errorTitle = CommonHelper.instance.getTitleErrorByCode(
          code: 500,
          lang: widget.language
        );
        errorDesc = CommonHelper.instance.getDescErrorByCode(
          code: 500,
          lang: widget.language
        );
      });
    }
  }
}