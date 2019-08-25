import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Response/NearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceNearYouItem.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerPlaceNearYou.dart';
import 'package:nerb/Views/Components/misc/WrapperError.dart';
import 'package:nerb/Views/Pages/DetailPlaces.dart';

class Related extends StatefulWidget {

  final String href;
  Related({@required this.href});

  @override
  _RelatedState createState() => new _RelatedState();
}

class _RelatedState extends State<Related> implements RequestResponseCallback{

  int statusCode = 500;
  bool isAlreadyRequired = false;
  int viewState = 1;

  NearbyPlaceResponse places;

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      width: MediaQuery.of(context).size.width,
      height: 230,
      child: viewState == 0 ?
        ListView(
          shrinkWrap: true,
          addRepaintBoundaries: true,
          scrollDirection: Axis.horizontal,
          children: places.nearbyPlaces.map((plc){
            String img = CommonHelper.instance.getPlaceImageByCategory(category: plc.category.id.toLowerCase());
            if(img == null){
              if(plc.category.title.contains("/")){
                List<String> plcs = plc.category.title.split("/");
                for(int i= 0; i < plcs.length; i++){
                  img = CommonHelper.instance.getPlaceImageByCategory(category: plcs[i].toLowerCase());
                  if(plc != null){
                    i = plcs.length;
                  }
                }
              }else{
                img = CommonHelper.instance.getPlaceImageByCategory(category: plc.category.title.toLowerCase());
              }
            }
            return PlaceNearYouItem(
              place: plc,
              callback: (){
                NerbNavigator.instance.removeThenPush(context,
                  child : DetailPlaces(
                    place: plc,
                    img: img,
                  )
                );
              },
            );
          }).toList(),
        )
        : Stack(
          children: <Widget>[
            // Positioned.fill(
            //   child: ShimmerPlaceNearYou(),
            // ),

            viewState == 2 ?
            Positioned.fill(
              child: WrapperError(
                title: CommonHelper.instance.getTitleErrorByCode(context: context, code: statusCode),
                desc: CommonHelper.instance.getDescErrorByCode(context: context, code: statusCode),
                buttonText: UserLanguage.of(context).button("retry"),
                height: 230,
                callback: (){
                  if(mounted){
                    setState(() {
                      isAlreadyRequired = false;
                      viewState = 1;
                      initiateData();
                    });
                  }
                },
              ),
            )
            : Container()
          ],
        )
      ,
    );
  }

  initiateData(){
    PlaceController.instance.getNearbyPlaceByNext(
      callback: this,
      language: "en",
      next: widget.href
    );
  }

  @override
  onFailureWithResponse(Response res) {
    if(mounted){
      setState(() {
        isAlreadyRequired = false;
        statusCode = res.statusCode;
        viewState = 2;
      });
    }
  }

  @override
  onSuccessResponseFailed(Map<String,dynamic> data) {
    if(data['statusCode'] == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyRequired){
        Timer(const Duration(seconds: 2), (){
          initiateData();
        });
      }else{
        if(mounted){
          setState(() {
            isAlreadyRequired = false;
            statusCode = data['statusCode'];
            viewState = 2;
          });
        }
      }
    }else{
      if(mounted){
        setState(() {
          isAlreadyRequired = false;
          statusCode = data['statusCode'];
          viewState = 2;
        });
      }
    }
  }

  @override
  onSuccessResponseSuccess(Map<String,dynamic> data) {
    places = NearbyPlaceResponse.fromNextResponse(data['result']);
    if(mounted){
      setState(() {
        isAlreadyRequired = false;
        viewState = 0;
      });
    }
  }

  @override
  onfailure() {
    if(mounted){
      setState(() {
        isAlreadyRequired = false;
        statusCode = 500;
        viewState = 2;
      });
    }
  }
}