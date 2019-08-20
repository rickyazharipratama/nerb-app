import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:store_redirect/store_redirect.dart';

class MinorUpdate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Material(
        color: Theme.of(context).backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  Expanded(
                    child: Text(
                      UserLanguage.of(context).title("update"),
                      style: Theme.of(context).primaryTextTheme.subhead,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    splashColor: ColorCollections.shimmerHighlightColor,
                    highlightColor: ColorCollections.shimmerBaseColor,
                    borderRadius: BorderRadius.circular(12.5),
                    child:  Center(
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: Stack(
                children: <Widget>[

                    Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.cloud_download,
                          color: Theme.of(context).brightness == Brightness.dark ? ColorCollections.titleColor : ColorCollections.shimmerBaseColor,
                          size: MediaQuery.of(context).size.width  /  2,
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child:  Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                UserLanguage.of(context).desc("update"),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).primaryTextTheme.body1,
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.of(context, rootNavigator: true).pop();
                                StoreRedirect.redirect(
                                  androidAppId: "com.teamCoret.nerb"
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  UserLanguage.of(context).button("update").toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).primaryTextTheme.button,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}