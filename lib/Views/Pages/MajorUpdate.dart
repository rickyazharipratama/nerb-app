import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/Response/AppVersion.dart';
import 'package:store_redirect/store_redirect.dart';

class MajorUpdate extends StatefulWidget {

  final bool isMajor;

  MajorUpdate({this.isMajor : true});

  @override
  _MajoUpdateState createState() => new _MajoUpdateState();
}

class _MajoUpdateState extends State<MajorUpdate> {

  RemoteConfig rc;
  AppVersion version;

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: <Widget>[

          Positioned.fill(
            child: Center(
              child: Icon(
                Icons.cloud_download,
                color: Theme.of(context).brightness == Brightness.dark ? ColorCollections.titleColor : ColorCollections.shimmerBaseColor,
                size: MediaQuery.of(context).size.width * 3 /  4,
              ),
            ),
          ),

          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                            UserLanguage.of(context).title("update"),
                            style: Theme.of(context).primaryTextTheme.title,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          UserLanguage.of(context).desc("update"),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).primaryTextTheme.body1,
                        ),
                      ),
                      version != null ?
                        version.descs.length > 0 ?
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).highlightColor,
                                width: 1
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  UserLanguage.of(context).label("wn"),
                                  style: Theme.of(context).primaryTextTheme.body1,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: version.descs.map((vs){
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "●",
                                              style: Theme.of(context).primaryTextTheme.body1,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Text(
                                                  vs.desc,
                                                  style: Theme.of(context).primaryTextTheme.body1,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              ],
                            )
                          )
                        : Container()
                      :Container(),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                          child: InkWell(
                            highlightColor: ColorCollections.shimmerHighlightColor,
                            splashColor: ColorCollections.shimmerBaseColor,
                            borderRadius: BorderRadius.circular(5),
                            onTap: (){
                              StoreRedirect.redirect(
                                androidAppId: "com.teamCoret.nerb",
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).buttonColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                              child: Center(
                                child: Text(
                                  UserLanguage.of(context).button("update"),
                                  style: Theme.of(context).primaryTextTheme.button,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  initiateData() async{
    rc = await CommonHelper.instance.fetchRemoteConfig();
    String tmp = rc.getString(ConstantCollections.REMOTE_CONFIG_UPDATE_VERSION);
    if(mounted){
      setState(() {
        if(tmp != null){
          version = AppVersion.fromJson(jsonDecode(tmp));
        }
      });
    }
  }

}