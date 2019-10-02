import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/PresenterViews/WrapperPermissionView.dart';
import 'package:nerb/Presenters/WrapperPermissionPresenter.dart';
import 'package:nerb/Views/Components/misc/Permissions.dart';

class WrapperPermission extends StatefulWidget {
  
  final WrapperPermissionPresenter presenter = WrapperPermissionPresenter();
  @override
  _WrapperPermissionState createState() => new _WrapperPermissionState();
}

class _WrapperPermissionState extends State<WrapperPermission> with WrapperPermissionView{

  @override
  void initState() {
    super.initState();
    widget.presenter.setView = this;
    widget.presenter.initiateData();
  }

  @override
  BuildContext currentContext() {
    return context;
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Material(
      color: Theme.of(context).backgroundColor,
      child: PageView(
        controller: pageController,
        onPageChanged: (active){
          if(mounted){
            setState(() {
              setActiveIndex = active;
            });
          }
        },
        children: <Widget>[
          Permissions(
            forPermission: ConstantCollections.PERMISSION_LOCATION,
            title: UserLanguage.of(context).title("locationPermission"),
            desc: UserLanguage.of(context).desc("locationPermission"),
            grantListener: goToLandingPage,
            icon: Icons.place,
          )
        ],
      ),
    );
  }
}