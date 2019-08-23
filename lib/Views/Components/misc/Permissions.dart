import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';

class Permissions extends StatefulWidget {

  final IconData icon;
  final String title;
  final String desc;
  final String forPermission;
  final VoidCallback grantListener;

  Permissions({@required this.icon, @required this.title, @required this.desc, @required this.forPermission, @required this.grantListener});

  
  @override
  _PermissionsState createState() => new _PermissionsState();
}

class _PermissionsState extends State<Permissions> with WidgetsBindingObserver{

  bool isNeedOpenSetting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initiateData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
      if(state == AppLifecycleState.resumed){
         PermissionStatus perm = await LocationPermissions().checkPermissionStatus();
         if(perm == PermissionStatus.granted){
           widget.grantListener();
         } 
      }
  }

  initiateData() async{
    if(widget.forPermission == ConstantCollections.PERMISSION_LOCATION){
      if(Platform.isAndroid){
        // if(!(await LocationPermissions().shouldShowRequestPermissionRationale())){
        //   if(mounted){
        //     setState(() {
        //       isNeedOpenSetting = true;
        //     });
        //   }
        // }
      }else if(Platform.isIOS){
        if(await LocationPermissions().checkPermissionStatus() == PermissionStatus.denied){
          if(mounted){
            setState(() {
              isNeedOpenSetting = true;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Container(
      padding:  EdgeInsets.fromLTRB(20,MediaQuery.of(context).padding.top + 20,20,MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          
          Expanded(
            child: Center(
              child : Icon(
                widget.icon,
                size: MediaQuery.of(context).size.width - 40,
                color: Theme.of(context).highlightColor, 
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.title,
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 5, bottom: 20),
            child: Text(
              widget.desc,
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ),

          Container(
            child : Center(
              child: InkWell(
                onTap: doPermission,
                splashColor: ColorCollections.shimmerBaseColor,
                highlightColor: ColorCollections.shimmerHighlightColor,
                child: Container(
                  color: Theme.of(context).buttonColor,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    isNeedOpenSetting ? UserLanguage.of(context).button("openAppSetting") : UserLanguage.of(context).button("requestPermission"),
                    style: Theme.of(context).primaryTextTheme.button,
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }

  doPermission() async{
    if(isNeedOpenSetting){
      await LocationPermissions().openAppSettings();
    }else{
      if(widget.forPermission == ConstantCollections.PERMISSION_LOCATION){
        print("requesting permission");
        PermissionStatus perm = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationWhenInUse
        );
        if(perm == PermissionStatus.granted){
           widget.grantListener();
        }else{
          print(perm.toString());
          if(Platform.isAndroid){
            bool isShown = await LocationPermissions().shouldShowRequestPermissionRationale();
            if(!isShown){
              if(mounted){
                setState(() {
                  isNeedOpenSetting = true;
                });
              }
            }
          }else if(Platform.isIOS){
            if(mounted){
              setState(() {
                isNeedOpenSetting = true;
              });
            }
          }else{
            //prob fuchsia
          }
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
}