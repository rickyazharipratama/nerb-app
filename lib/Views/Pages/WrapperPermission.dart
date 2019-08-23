import 'package:flutter/material.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Views/Components/misc/Permissions.dart';
import 'package:nerb/Views/Pages/LandingPage.dart';

class WrapperPermission extends StatefulWidget {
  @override
  _WrapperPermissionState createState() => new _WrapperPermissionState();
}

class _WrapperPermissionState extends State<WrapperPermission> {

  PageController controller;

  int activeIndex = 0; 
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: activeIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: PageView(
          controller: controller,
          onPageChanged: (active){
            if(mounted){
              setState(() {
                activeIndex = active;
              });
            }
          },
          children: <Widget>[
            Permissions(
              forPermission: ConstantCollections.PERMISSION_LOCATION,
              title: UserLanguage.of(context).title("locationPermission"),
              desc: UserLanguage.of(context).desc("locationPermission"),
              grantListener: (){
                  NerbNavigator.instance.newClearRoute(context,
                    child: LandingPage()
                  );
              },
              icon: Icons.place,
            )
          ],
        ),
    );
  }
}