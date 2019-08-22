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
import 'package:nerb/Views/Components/Shimmers/ShimmerGridPlaces.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerListPlaces.dart';
import 'package:nerb/Views/Components/misc/ErrorPlaceholder.dart';
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

  int statusCode = 500;
  bool isAlreadyRetry = false;

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
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                viewState == 0 ?
                  nearbyPlaces.nearbyPlaces.length > 0 ?
                    Positioned.fill(
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
                      :  Container()
                    )
                    : Positioned.fill(
                      child: Center(
                        child: ErrorPlaceholder(
                          title: UserLanguage.of(context).title("aw"),
                          desc: UserLanguage.of(context).desc("emptyPlace"),
                          isNeedButton: false,
                          icon: Icons.location_off,
                        ),
                      ),
                    )
                : viewState == 1 ?
                  Positioned.fill(
                    child: mode == 0 ?
                      ShimmerListPlaces()
                      : mode == 1 ?
                        ShimmerGridPlaces()
                      : Container(),
                     )
                : Positioned.fill(
                  child: ErrorPlaceholder(
                    title: CommonHelper.instance.getTitleErrorByCode(
                      code: statusCode,
                      context: context
                    ),
                    desc: CommonHelper.instance.getDescErrorByCode(
                      code: statusCode,
                      context: context
                    ),
                    isNeedButton: true,
                    buttonText: UserLanguage.of(context).button('retry').toUpperCase(),
                    callback: (){
                      isAlreadyRetry = false;
                      if(mounted){
                        setState(() {
                          viewState = 1;
                          initiateData();
                        });
                      }
                    },
                  )
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
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
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            decoration: BoxDecoration(
                              color: mode == 0 ? Theme.of(context).buttonColor : Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 1.5,
                                  color: Theme.of(context).buttonColor,
                                  offset: Offset(1.5,3)
                                )
                              ],
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
                            padding: const EdgeInsets.fromLTRB(30,5,30,5),
                            decoration: BoxDecoration(
                              color: mode == 1 ? Theme.of(context).buttonColor : Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 1.5,
                                  color: Theme.of(context).buttonColor,
                                  offset: Offset(-1.5,3)
                                )
                              ]
                            ),
                            child: Icon(
                              Icons.view_module,
                              size: 20,
                              color: Theme.of(context).brightness == Brightness.light ? mode == 1 ? Colors.white : Theme.of(context).primaryTextTheme.body1.color : Theme.of(context).primaryTextTheme.body1.color,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        )
                      ],
                    ),
                )
              ],
            )
          )
        ],
      ),
    ); 
  }

  initiateData() async{
    currLoc = Location();
    LocationData dt = await currLoc.getLocation();
    int radius = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);
    PlaceController.instance.getNearbyPlace(
      callback: this,
      location: dt.latitude.toString()+","+dt.longitude.toString(),
      language: UserLanguage.of(context).currentLanguage,
      radius: radius.toString(),
      type: widget.forSearch
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  onFailureWithResponse(Response res) {
    if(mounted){
      setState(() {
        statusCode = res.statusCode;
        responseState = RequestResponseState.onFailureWithResponse;
        viewState = 2;
      });
    }
  }

  @override
  onSuccessResponseFailed(Map<String,dynamic> data){
    if(data['statusCode'] == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyRetry){
        isAlreadyRetry = true;
        initiateData();
      }else{
        if(mounted){
          setState(() {
            responseState = RequestResponseState.onSuccessResponseFailed;
            statusCode = data['statusCode'];
            viewState = 2;
          });
        }
      }
    }else{
      if(mounted){
        setState(() {
          responseState = RequestResponseState.onSuccessResponseFailed;
          statusCode = data['statusCode'];
          viewState = 2;
        });
      }
    }
  }

  @override
  onSuccessResponseSuccess(Map<String,dynamic> data) async{
    nearbyPlaces = NearbyPlaceResponse.fromJson(data['result']);
    nearbyPlaces.setLastFetch = DateTime.now().millisecondsSinceEpoch;
    LocationData dt = await currLoc.getLocation();

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