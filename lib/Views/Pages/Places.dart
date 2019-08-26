import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:nerb/Views/Modals/ErrorModal.dart';

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

  ScrollController scController;

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

  int requestMode = 0;
  bool isProcessRequest = false;

  RequestResponseState responseState;


  @override
  void initState() {
    super.initState();
    scController = ScrollController(
      debugLabel: "place-scroll");
    scController.addListener((){
      if(scController.offset >= scController.position.maxScrollExtent && !scController.position.outOfRange){
        if(!isProcessRequest){
          if(nearbyPlaces != null){
             if(nearbyPlaces.getNext != null){
               print("requesting next data");
              if(mounted){
                setState(() {
                  requestMode = 1;
                  isProcessRequest = true;
                  PlaceController.instance.getNearbyPlaceByNext(
                    language: UserLanguage.of(context).currentLanguage,
                    callback: this,
                    next: nearbyPlaces.getNext
                  ); 
                });
              }
             }
          }else{
             print("there is no  data");
          }
        }else{
          print("still request");
        }
      }
    });
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
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
                            controller: scController,
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
                          controller: scController,
                          children: nearbyPlaces.nearbyPlaces.map((place){
                            return DetailPlace(
                              place: place,
                              mode: 1,
                            );
                          }).toList(),
                        )
                      :  Container()
                    )
                    : Stack(
                      children: <Widget>[
                          Positioned.fill(
                            child: ShimmerListPlaces(),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: ErrorPlaceholder(
                                title: UserLanguage.of(context).title("aw"),
                                desc: UserLanguage.of(context).desc("emptyPlace"),
                                isNeedButton: false,
                                icon: Icons.location_off,
                              ),
                            ),
                          )
                      ],
                    )
                : Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: mode == 0 ?
                        ShimmerListPlaces()
                        : mode == 1 ?
                          ShimmerGridPlaces()
                        : Container(),
                      ),
                     viewState == 2 ?
                      Positioned.fill(
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
                          buttonText: UserLanguage.of(context).button('retry'),
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
                      )
                     :Container()
                  ],
                ),
                viewState == 0 ?
                nearbyPlaces.nearbyPlaces.length > 0 ?
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
                                color: Theme.of(context).brightness == Brightness.light ? mode == 0 ? Colors.white : Theme.of(context).primaryTextTheme.body1.color : mode == 0 ? Color(0xff585858) :Theme.of(context).primaryTextTheme.body1.color,
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
                                color: Theme.of(context).brightness == Brightness.light ? mode == 1 ? Colors.white : Theme.of(context).primaryTextTheme.body1.color : mode == 1 ? Color(0xff585858) : Theme.of(context).primaryTextTheme.body1.color,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          )
                        ],
                      ),
                  ) : Container() : Container()
              ],
            ),
          ),
          AnimatedCrossFade(
            crossFadeState: requestMode == 1 && isProcessRequest ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Container(
              padding: EdgeInsets.only(top: 5, bottom: MediaQuery.of(context).padding.bottom + 10),
              child: Center(
                child: SpinKitThreeBounce(
                  color: Theme.of(context).buttonColor,
                  size: 20,
                ),
              ),
            ),
            secondChild: Container(),
            duration: const Duration(milliseconds: 300),
          )
        ],
      ),
    ); 
  }

  initiateData() async{
    requestMode = 0;
    currLoc = Location();
    LocationData dt = await currLoc.getLocation();
    int radius = await PreferenceHelper.instance.getIntValue(key: ConstantCollections.PREF_RADIUS);
    isProcessRequest = true;
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
    if(requestMode == 0){
      if(mounted){
        setState(() {
          isProcessRequest = false;
          statusCode = res.statusCode;
          responseState = RequestResponseState.onFailureWithResponse;
          viewState = 2;
        });
      }
    }else{
      if(mounted){
        setState(() {
          isProcessRequest = false;
          showModalBottomSheet(
            context: context,
            builder: (context) => ErrorModal(
              title: CommonHelper.instance.getTitleErrorByCode(context: context, code: res.statusCode),
              desc: CommonHelper.instance.getDescErrorByCode(context: context, code: res.statusCode),
            )
          );
        });
      }
    }
  }

  @override
  onSuccessResponseFailed(Response res){
    if(requestMode == 0){
      if(res.statusCode== ConstantCollections.STATUS_CODE_UNAUTHORIZE){
        if(!isAlreadyRetry){
          Timer(const Duration(seconds:  2), (){
            isAlreadyRetry = true;
            isProcessRequest = false;
            initiateData();
          });
        }else{
          if(mounted){
            setState(() {
              isProcessRequest = false;
              responseState = RequestResponseState.onSuccessResponseFailed;
              statusCode = res.statusCode;
              viewState = 2;
            });
          }
        }
      }else{
        if(mounted){
          setState(() {
            isProcessRequest = false;
            responseState = RequestResponseState.onSuccessResponseFailed;
            statusCode = res.statusCode;
            viewState = 2;
          });
        }
      }
    }else{
      if(res.statusCode== ConstantCollections.STATUS_CODE_UNAUTHORIZE){
        if(!isAlreadyRetry){
          isAlreadyRetry = true;
          isProcessRequest = false;
          if(mounted){
            setState(() {
              requestMode = 1;
              isProcessRequest = true;
              PlaceController.instance.getNearbyPlaceByNext(
                language: UserLanguage.of(context).currentLanguage,
                callback: this,
                next: nearbyPlaces.getNext
              );
            });
          }
        }else{
          if(mounted){
            setState(() {
              isProcessRequest = false;
              showModalBottomSheet(
                context: context,
                builder: (context) => ErrorModal(
                  title: CommonHelper.instance.getTitleErrorByCode(context: context, code: res.statusCode),
                  desc: CommonHelper.instance.getDescErrorByCode(context: context, code: res.statusCode),
                )
              );
            });
          }
        }
      }else{
        if(mounted){
          setState(() {
            isProcessRequest = false;
            showModalBottomSheet(
              context: context,
              builder: (context) => ErrorModal(
                title: CommonHelper.instance.getTitleErrorByCode(context: context, code: res.statusCode),
                desc: CommonHelper.instance.getDescErrorByCode(context: context, code: res.statusCode),
              )
            );
          });
        }
      }
    }
  }

  @override
  onSuccessResponseSuccess(Map<String,dynamic> data) async{
    if(requestMode == 0){
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
          isProcessRequest = false;
          viewState = 0;
        });
      }
    }else{
      NearbyPlaceResponse tmp = NearbyPlaceResponse.fromNextResponse(data['result']);
      if(tmp.next != null){
        nearbyPlaces.setNext = tmp.next;
      }else{
        nearbyPlaces.setNext = null;
      }
      if(tmp.getNearbyPlaces.length > 0){
        nearbyPlaces.setNearbyPlace = tmp.getNearbyPlaces;
      }
      if(mounted){
        setState(() {
          isProcessRequest = false;
        });
      }
    }
  }

  @override
  onfailure() {
    if(requestMode == 0){
      if(mounted){
        setState(() {
          isProcessRequest = false;
          responseState = RequestResponseState.onfailure;
          viewState = 2;
        });
      }
    }else{
      if(mounted){
        setState(() {
          isProcessRequest = false;
          showModalBottomSheet(
            context: context,
            builder: (context) => ErrorModal(
              title: CommonHelper.instance.getTitleErrorByCode(context: context, code: 500),
              desc: CommonHelper.instance.getDescErrorByCode(context: context, code: 500),
            )
          );
        });
      }
    }
  }
}