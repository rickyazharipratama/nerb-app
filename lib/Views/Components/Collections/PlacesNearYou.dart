import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Models/Response/NearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Buttons/FlexibleButton.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceNearYouItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerPlaceNearYou.dart';
import 'package:nerb/Views/Components/misc/WrapperError.dart';
import 'package:nerb/Views/Pages/Places.dart';

class PlacesNearYou extends StatefulWidget {

  PlacesNearYou();

  @override
  _PlacesNearYouState createState() => new _PlacesNearYouState();
}

class _PlacesNearYouState extends State<PlacesNearYou> implements RequestResponseCallback {

  int viewState = 1;
  bool isLoadError = false;
  int errorCode = 500;
  String errorStatus;
  NearbyPlaceResponse nearbyPlace;


  RequestResponseState responseState;

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
            padding: const EdgeInsets.only(left: 10, bottom: 7, right: 10),
              child: SectionTitle.withText(
                value: UserLanguage.of(context).title('placesNearYou')
              ),
          ),

          viewState == 0?
          Container(
            height: 230,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: nearbyPlace.nearbyPlaces.map((place){
                if(place.id == ConstantCollections.SEE_ALL){
                  return FlexibleButton(
                    title: UserLanguage.of(context).button("seeAll"),
                    background: Theme.of(context).highlightColor,
                    width: 180,
                    height: 230,
                    callback: (){
                      List<DetailNearbyPlaceResponse> tmp = List();
                      tmp.addAll(nearbyPlace.nearbyPlaces);
                      tmp.removeLast();
                      NerbNavigator.instance.push(context,
                        child: Places(
                          title: UserLanguage.of(context).title('placesNearYou'),
                          places: tmp,
                        )
                      );
                    },
                  );
                }
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
                    buttonText: UserLanguage.of(context).button("retry"),
                    title: responseState == RequestResponseState.onSuccessResponseFailed?
                      CommonHelper.instance.getTitleErrorByStatus(
                        context: context,
                        status: errorStatus
                      )
                      : responseState == RequestResponseState.onFailureWithResponse
                        || responseState == RequestResponseState.onfailure?
                        CommonHelper.instance.getTitleErrorByCode(
                          context: context,
                          code: errorCode
                        )
                        : CommonHelper.instance.getTitleErrorByCode(
                          context: context,
                          code: errorCode
                        )
                    ,
                    desc: responseState == RequestResponseState.onSuccessResponseFailed?
                      CommonHelper.instance.getDescErrorByStatus(
                        context: context,
                        status: errorStatus
                      )
                      : responseState == RequestResponseState.onFailureWithResponse
                        || responseState == RequestResponseState.onfailure ?
                        CommonHelper.instance.getDescErrorByCode(
                          context: context,
                          code: errorCode
                        )
                        : CommonHelper.instance.getDescErrorByCode(
                          context: context,
                          code: errorCode
                        ),
                    height: 140,
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
    await PlaceController.instance.getNearbyPlace(
      callback: this,
      location: dt.latitude.toString()+","+dt.longitude.toString(),
      language: UserLanguage.of(context).currentLanguage,
      radius: radius.toString()
    );
  }

  @override
  onFailureWithResponse(Response res) {
    if(mounted){
      setState(() {
        isLoadError = true;
        responseState = RequestResponseState.onFailureWithResponse;
        errorCode = res.statusCode;
        // errorTitle = CommonHelper.instance.getTitleErrorByCode(
        //   code: res.statusCode,
        //   context: context
        // );
        // errorDesc = CommonHelper.instance.getDescErrorByCode(
        //   code: res.statusCode,
        //   context: context
        // );
      });
    }
  }

  @override
  onSuccessResponseFailed(Map<String,dynamic> data) {
    if(mounted){
      setState((){
        isLoadError = true;
        responseState = RequestResponseState.onSuccessResponseFailed;
        errorStatus = data['status'];
        // errorTitle = CommonHelper.instance.getTitleErrorByStatus(
        //   status: data['status'],
        //   context: context
        // );
        // errorDesc = CommonHelper.instance.getDescErrorByStatus(
        //   status: data['status'],
        //   context: context
        // );
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
        responseState = RequestResponseState.onSuccessResponseSuccess;
      });
    }
  }

  @override
  onfailure() {
    if(mounted){
      setState(() {
        isLoadError = true;
        errorCode = 500;
        responseState = RequestResponseState.onfailure;
      });
    }
  }
}