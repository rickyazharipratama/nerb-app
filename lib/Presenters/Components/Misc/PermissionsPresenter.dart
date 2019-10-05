import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/PresenterViews/Components/Miscs/PermissionsView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class PermissionsPresenter extends BaseComponentPresenter{

  PermissionsView _view;
  bool _isNeedOpenSetting = false;
  final VoidCallback grantListener;
  final String forPermission;

  PermissionsPresenter({
    @required this.grantListener,
    @required this.forPermission
  });

  PermissionsView get view => _view;
  set setView(PermissionsView vw){
    _view = vw;
  }

  bool get isNeedOpenSetting => _isNeedOpenSetting;
  set setNeedOpenSetting(bool stg){
    _isNeedOpenSetting = stg;
  }

  checkGrantPermission() async{
    PermissionStatus perm = await LocationPermissions().checkPermissionStatus();
    if(perm == PermissionStatus.granted){
      grantListener();
    }
  }

  @override
  void initiateData()async{
    super.initiateData();
    if(forPermission == ConstantCollections.PERMISSION_LOCATION){
      if(Platform.isAndroid){

      }else if(Platform.isIOS){
        if(await LocationPermissions().checkPermissionStatus() == PermissionStatus.denied){
          setNeedOpenSetting = true;
          view.notifyState();
        }
      }
    }
  }

  doPermission()async{
    if(isNeedOpenSetting){
      await LocationPermissions().openAppSettings();
    }else{
      if(forPermission == ConstantCollections.PERMISSION_LOCATION){
        PermissionStatus perm = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationWhenInUse
        );
        if(perm == PermissionStatus.granted){
          grantListener();
        }else{
          if(Platform.isAndroid){
            bool isShown = await LocationPermissions().shouldShowRequestPermissionRationale();
            if(!isShown){
              setNeedOpenSetting = true;
              view.notifyState();
            }
          }else if(Platform.isIOS){
            setNeedOpenSetting = true;
            view.notifyState();
          }else{

          }
        }
      }
    }
  }
}