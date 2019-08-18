import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Response/NearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Collections/Items/DetailPlace.dart';
import 'package:nerb/Views/Components/misc/NerbPushAppBar.dart';

class Places extends StatefulWidget {

  final String title;
  final String forSearch;

  Places({@required this.title, @required this.forSearch});

  @override
  _PlacesState createState() => new _PlacesState();
}

class _PlacesState extends State<Places> implements RequestResponseCallback{

  NearbyPlaceResponse nearbyPlaces;
  String nextToken;

  //0 list
  //1 grid
  //2
  int mode = 0;
  LocationData myloc;

  // 0 main
  //1 loading
  int viewState = 1;
  Location currLoc;

  int errorCode = 500;

  RequestResponseState responseState;


  @override
  void initState() {
    super.initState();
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          NerbPushAppBar(
            title: widget.title,
            buttom: Padding(
              padding: const EdgeInsets.only(top: 5, right: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  
                  GestureDetector(
                    onTap: (){
                      if(mode != 0){
                        if(mounted){
                          setState(() {
                            mode = 0;
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: mode == 0 ? Theme.of(context).buttonColor : Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(5)
                        )
                      ),
                      child: Icon(
                        Icons.menu,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.light ? mode == 0 ? Colors.white : Theme.of(context).primaryTextTheme.body1.color : Theme.of(context).primaryTextTheme.body1.color,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      if(mode != 1){
                        if(mounted){
                          setState(() {
                            mode = 1;
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                      decoration: BoxDecoration(
                        color: mode == 1 ? Theme.of(context).buttonColor : Theme.of(context).highlightColor,
                      ),
                      child: Icon(
                        Icons.view_module,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.light ? mode == 1 ? Colors.white : Theme.of(context).primaryTextTheme.body1.color : Theme.of(context).primaryTextTheme.body1.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: mode == 0 ?
                ListView(
                  children: nearbyPlaces.nearbyPlaces.map((place){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: DetailPlace(
                        place: place,
                      ),
                    );
                  }).toList(),
                )
              : mode == 1 ?
                GridView.count(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  childAspectRatio: 9/16,
                  children: nearbyPlaces.nearbyPlaces.map((place){
                    return DetailPlace(
                      place: place,
                      mode: 1,
                    );
                  }).toList(),
                )
              :  Container(),
          )
        ],
      ),
    ); 
  }

  initiateData() async{
    String lastNearbyPlace = await PreferenceHelper.instance.getStringValue(
      key: ConstantCollections.PREF_NEARBY_PLACE
    );
    currLoc = Location();
    LocationData dt = await currLoc.getLocation();
    if(lastNearbyPlace != null){
      NearbyPlaceResponse tmp = NearbyPlaceResponse.fromJson(jsonDecode(lastNearbyPlace));
      bool isNeedRefresh = await CommonHelper.instance.isNeedToRefreshNearbyPlace(tmp.lastFetch);
      if(!isNeedRefresh){
        if(mounted){
          setState(() {
            nearbyPlaces = tmp;
            viewState = 0;
          });
        }
      }else{
        int radius = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);
        await PlaceController.instance.getNearbyPlace(
          callback: this,
          location: dt.latitude.toString()+","+dt.longitude.toString(),
          language: UserLanguage.of(context).currentLanguage,
          radius: radius.toString()
        );
      }
    }else{
      int radius = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);
      await PlaceController.instance.getNearbyPlace(
        callback: this,
        location: dt.latitude.toString()+","+dt.longitude.toString(),
        language: UserLanguage.of(context).currentLanguage,
        radius: radius.toString()
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  onFailureWithResponse(Response res) {
    if(mounted){
      setState(() {
        errorCode = res.statusCode;
        responseState = RequestResponseState.onFailureWithResponse;
        viewState = 2;
      });
    }
  }

  @override
  onSuccessResponseFailed(Map<String,dynamic> data){
    if(mounted){
      setState(() {
         responseState = RequestResponseState.onSuccessResponseFailed;
         viewState = 2;
      });
    }
  }

  @override
  onSuccessResponseSuccess(Map<String,dynamic> data) async{
    nearbyPlaces = NearbyPlaceResponse.fromJson(data);
    nearbyPlaces.setLastFetch = DateTime.now().millisecondsSinceEpoch;
    LocationData dt = await currLoc.getLocation();
    PreferenceHelper.instance.setStringValue(
      key: ConstantCollections.PREF_NEARBY_PLACE,
      value: jsonEncode(nearbyPlaces.getMap())
    );
    PreferenceHelper.instance.setStringValue(
      key: ConstantCollections.PREF_LAST_LOCATION,
      value: dt.latitude.toString()+","+dt.longitude.toString()
    );
    responseState = RequestResponseState.onSuccessResponseSuccess;
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
        responseState = RequestResponseState.onfailure;
      });
    }
  }
}