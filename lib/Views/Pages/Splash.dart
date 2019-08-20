import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Views/Pages/LandingPage.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  bool isNeedGetKey = false;
  bool isNeedGetCategory = false;
  bool isNeedGetPlaces = false;

  int hereApiVersion;
  int lastSavedCategoriesVersion;
  int lastSavedPlaceVersion;

  bool isError = false;
  RemoteConfig remoteConfig;
  bool isNeedLoading = true;

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children:<Widget>[
          Positioned.fill(
            child:Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Theme.of(context).brightness == Brightness.light ? "assets/nerb-black.png" : "assets/nerb-white.png",
                    width: 85,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Text(
                      UserLanguage.of(context).desc("splash"),
                      style: Theme.of(context).textTheme.body1
                    ),
                  )
                ],
              )
            ),
          ),
          isNeedLoading ?
            Positioned(
              bottom: 15 + MediaQuery.of(context).padding.bottom,
              right: 0,
              left: 0,
              child: Center(
                child: SpinKitThreeBounce(
                  color: Theme.of(context).buttonColor,
                  size: 50,
                ),
              ),
            )
          : Container()
        ]
      ) 
    );
  }

  initiateData() async{
    bool isMaintenance = await CommonHelper.instance.checkMaintenance(context);
    bool isMajorUpdate = await CommonHelper.instance.isMajorUpdateVersion(context);
    if(!isMaintenance){
      if(!isMajorUpdate){
        remoteConfig = await CommonHelper.instance.fetchRemoteConfig();
        
        String appId  = await PreferenceHelper.instance.getSecureStorage(
          key: ConstantCollections.PREF_APP_ID
        );
        String appCode = await PreferenceHelper.instance.getSecureStorage(
          key: ConstantCollections.PREF_APP_CODE
        );
        hereApiVersion = await PreferenceHelper.instance.getIntValue(
          key: ConstantCollections.PREF_LAST_HERE_API_VERSION
        );

        if(hereApiVersion > 0){
          int remoteHereVersion = remoteConfig.getInt(ConstantCollections.REMOTE_CONFIG_HERE_API_VERSION);
          if(hereApiVersion  < remoteHereVersion){
            hereApiVersion = remoteHereVersion;
            isNeedGetKey = true;
          }
        }else{
          if(appId == null || appCode == null){
            isNeedGetKey = true;
            hereApiVersion = 1;
          }
        }

        lastSavedCategoriesVersion = await PreferenceHelper.instance.getIntValue(
          key: ConstantCollections.PREF_LAST_CATEGORY_VERSION
        );

        if(lastSavedCategoriesVersion > 0){
          int remoteCategoriesVersion = remoteConfig.getInt(ConstantCollections.REMOTE_CONFIG_CATEGORY_VERSION);
          if(lastSavedCategoriesVersion < remoteCategoriesVersion){
            isNeedGetCategory = true;
            lastSavedCategoriesVersion = remoteCategoriesVersion;
          }
        }else{
          isNeedGetCategory = true;
          lastSavedCategoriesVersion = 1;
        }

        lastSavedPlaceVersion = await PreferenceHelper.instance.getIntValue(
          key: ConstantCollections.PREF_LAST_PLACE_VERSION
        );
        if(lastSavedPlaceVersion > 0){
          int remotePlaceVersion = remoteConfig.getInt(ConstantCollections.REMOTE_CONFIG_PLACES_VERSION);
          if(lastSavedPlaceVersion < remotePlaceVersion){
            isNeedGetPlaces = true;
            lastSavedPlaceVersion = remotePlaceVersion;
          }
        }else{
          isNeedGetPlaces = true;
          lastSavedPlaceVersion = 1;
        }
        if(!isNeedGetKey && !isNeedGetCategory && !isNeedGetPlaces){
          await openLAstAct();
        }else{
          await fetchFireStoreKeyData();
        }
      }
    }
  }

  Future<void>fetchFireStoreKeyData() async{
    if(isNeedGetKey || isNeedGetCategory || isNeedGetPlaces){
      Timer(
        const Duration(milliseconds: 500),() async{
          if(mounted){
            setState(() {
              isNeedLoading = true;
              if(isNeedGetKey){
                Firestore.instance.collection(ConstantCollections.FIRESTORE_HERE_KEY)
                  .snapshots()
                  .listen((QuerySnapshot snapshot){
                    DocumentSnapshot data = snapshot.documents[0];
                    PreferenceHelper.instance.setSecureStorage(
                      key: ConstantCollections.PREF_APP_CODE,
                      val: data['appCode']
                    );
                    PreferenceHelper.instance.setSecureStorage(
                      key: ConstantCollections.PREF_APP_ID,
                      val: data['appId']
                    );
                    PreferenceHelper.instance.setIntValue(
                      key: ConstantCollections.PREF_LAST_HERE_API_VERSION,
                      value: hereApiVersion
                    );
                    isNeedGetKey = false;
                    getCategoryData();
                  })
                  .onError((){
                    isError = true;
                  });
              }else{
                getCategoryData();
              }  
            });
          }
        }
      );
    }
  }

  getCategoryData(){
    if(isNeedGetCategory){
      Firestore.instance.collection(ConstantCollections.FIRESTORE_CATEGORY)
      .snapshots()
      .listen((QuerySnapshot snapshot){
        print("enter categori");
        List<String> categories = List();
        snapshot.documents.forEach((cat){
          cat.data['id'] = cat.documentID;
          categories.add(jsonEncode(cat.data));
        });
        PreferenceHelper.instance.setStringListValue(
          key: ConstantCollections.PREF_LAST_CATEGORY,
          value: categories
        );
        PreferenceHelper.instance.setIntValue(
          key: ConstantCollections.PREF_LAST_CATEGORY_VERSION,
          value: lastSavedCategoriesVersion
        );
        isNeedGetCategory = false;
        getPlaceData();
      })
      .onError((){
        isError = true;
      });
    }else{
      getPlaceData();
    }
  }

  getPlaceData(){
    if(isNeedGetPlaces){
      Firestore.instance.collection(ConstantCollections.FIRESTORE_PLACE)
      .snapshots()
      .listen((QuerySnapshot snapshots){
        print("enter place");
        List<String> places = List();
        snapshots.documents.forEach((plc){
          plc.data['id'] = plc.documentID;
          places.add(jsonEncode(plc.data));
        });
        PreferenceHelper.instance.setStringListValue(
          key: ConstantCollections.PREF_LAST_PLACE,
          value: places
        );
        PreferenceHelper.instance.setIntValue(
          key: ConstantCollections.PREF_LAST_PLACE_VERSION,
          value: lastSavedPlaceVersion
        );
        isNeedGetPlaces = false;
        openLAstAct();
        
      })
      .onError((){
        isError = true;
      });
    }else{
      openLAstAct();
    }
  }

  openLAstAct() async{
    if(!isError){
      Location loc = Location();
      if(! await loc.hasPermission()){
        await loc.requestPermission();
      }
      if(await loc.hasPermission()){
        NerbNavigator.instance.newClearRoute(context,
          child: LandingPage()
        );   
      } 
    }
  }
}