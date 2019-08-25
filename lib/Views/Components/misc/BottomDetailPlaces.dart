import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/DistanceHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/Response/SpecificDetailPlaceResponse.dart';
import 'package:nerb/Views/Components/Collections/Related.dart';
import 'package:nerb/Views/Components/misc/Separator.dart';
import 'package:url_launcher/url_launcher.dart';
class BottomDetailPlaces extends StatelessWidget  {

  final double currentOffsetPercent;
  final ValueChanged<bool> animate;
  final ValueChanged<DragUpdateDetails> onVerticalDrugUpdate;
  final VoidCallback panDown;
  final bool isOpen;
  final SpecificDetailPlaceResponse place;
  final int distance;

  BottomDetailPlaces({@required this.isOpen, @required this.currentOffsetPercent, @required this.animate, @required this.onVerticalDrugUpdate, @required this.panDown, @required this.place, @required this.distance});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        animate(!isOpen);
      },
      onVerticalDragUpdate: onVerticalDrugUpdate,
      onVerticalDragEnd: (details){
        if(!isOpen){
          if(currentOffsetPercent < 0.2){
            animate(true);
          }else{
            animate(false);
          }
        }else{
          if(currentOffsetPercent > 0.8){
            animate(false);
          }else{
            animate(true);
          }
        }
      },
      onPanDown: (_) => panDown(),
      child: Container(
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        height: (35 + MediaQuery.of(context).padding.bottom) + (((MediaQuery.of(context).size.height - 100) - (35 + MediaQuery.of(context).padding.bottom)) * currentOffsetPercent),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Color(0x77000000),
              blurRadius: 2,
              spreadRadius: 1,
              offset: Offset(0.1,0)
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            Container(
              height: 35,
              child: Center(
                child : Icon(
                  Icons.drag_handle,
                  color: Theme.of(context).primaryTextTheme.title.color,
                  size: 35,
                )
              ),
            ),

            Flexible(
              child: Container(
                height: 1 + ((MediaQuery.of(context).size.height - (134 + MediaQuery.of(context).padding.bottom)) * currentOffsetPercent),
                child : AnimatedCrossFade(
                  crossFadeState: currentOffsetPercent > 0.8 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 500),
                  firstCurve: Curves.ease,
                  secondCurve: Curves.ease,
                  secondChild: Container(),
                  firstChild: detailContent(context),
                ),
              )
            )
          ],
        )
      ),
    );
  }

  Widget detailContent(BuildContext context){
    return  Container(
      height: 1 + ((MediaQuery.of(context).size.height - (134 + MediaQuery.of(context).padding.bottom)) * currentOffsetPercent),
      child: ListView(
        scrollDirection: Axis.vertical, 
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).highlightColor
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                            Icon(
                              Icons.directions,
                              size: 25,
                              color: Theme.of(context).buttonColor,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                 DistanceHelper.instance.getFormatDistance(context, (distance.toDouble() / 1000)),
                                 style: Theme.of(context).primaryTextTheme.body1,
                              ),
                            )

                        ],
                      )
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            place.name,
                            style: Theme.of(context).primaryTextTheme.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              place.location.address.text.replaceAll("<br/>", "\n"),
                              style: Theme.of(context).primaryTextTheme.body1,
                            ),
                          ),

                          place.tags.length > 0 ?
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 5,
                              runSpacing: 5,
                              children: place.tags.map((tg){
                                return Container(
                                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Theme.of(context).highlightColor
                                  ),
                                  child: Text(
                                    tg.title,
                                    style: Theme.of(context).primaryTextTheme.body1,
                                  ),
                                );
                              }).toList(),
                            )
                          :Container()
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15 , 5, 15, 5),
              child: Separator(),
            ),

            place.extended != null ?
              place.extended.openingHours != null ?
                listBadge(context,
                  title: UserLanguage.of(context).label("openingHour"),
                  desc: place.extended.openingHours.text.replaceAll("<br/>", "\n"),
                  icon: Icons.query_builder
                )
              :Container()
            :Container(),

            Padding(
              padding: const EdgeInsets.fromLTRB(10 , 5, 10, 5),
              child: Separator(),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: badge(context,
                      padding: const EdgeInsets.fromLTRB(0, 5, 7.5, 5),
                      icon: Icons.phone,
                      val: place.contact != null ? place.contact.phone : List()
                    ),
                  ),
                  Expanded(
                    child: badge(context,
                      padding: const EdgeInsets.fromLTRB(7.5, 5, 7.5, 5),
                      val: place.contact != null ? place.contact.email : List(),
                      icon: Icons.email
                    ),
                  ),
                  Expanded(
                    child: badge(context,
                      padding: const EdgeInsets.fromLTRB(7.5, 5, 0, 5),
                      val: place.contact != null ? place.contact.website : List(),
                      icon: Icons.public
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15 , 5, 15, 5),
              child: Separator(),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  place.related != null ?
                    place.related.publicTransport != null ?
                      place.related.publicTransport.href != null ?
                        Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 10, right: 15, top: 20),
                          child: Text(
                            UserLanguage.of(context).label("publicTransportNearby"),
                            style: Theme.of(context).primaryTextTheme.subtitle,
                          )
                        )
                      :Container()
                    :Container() 
                  : Container(),

                  place.related != null ?
                    place.related.publicTransport != null ?
                      place.related.publicTransport.href != null ?
                        Related(
                          href: place.related.publicTransport.href,
                        )
                      :Container()
                    :Container() 
                  : Container(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  place.related != null ?
                    place.related.recommended != null ?
                      place.related.recommended.href != null ?
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 10, right: 15, top : 10),
                        child: Text(
                          UserLanguage.of(context).label("nearby"),
                          style: Theme.of(context).primaryTextTheme.subtitle,
                        )
                      )
                      :Container()
                    :Container()
                  :Container(),

                  place.related != null ?
                    place.related.recommended != null ?
                      place.related.recommended.href != null ?
                        Related(
                          href: place.related.recommended.href,
                        )
                      :Container()
                    :Container()
                  :Container()
                ],
              ),
            )
         ],
      ),
    );
  }

  Widget listBadge(BuildContext context, {IconData icon, String title, String desc}){
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).buttonColor,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    title,
                    style: Theme.of(context).primaryTextTheme.subhead,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    desc,
                    style: Theme.of(context).primaryTextTheme.body1,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget badge(BuildContext context,{ List<SpecificDetailPlaceDetailContact> val, IconData icon, EdgeInsets padding :const  EdgeInsets.all(7.5)}){
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
            
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).highlightColor
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Theme.of(context).buttonColor,
                  size: 17,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: val.length > 0 ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: val.map((vl){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: RichText(
                          softWrap: true,
                          text: vl.label.toLowerCase() == "website" ?
                            TextSpan(
                              style: Theme.of(context).textTheme.button,
                              text: place.name,
                              recognizer: TapGestureRecognizer()..onTap = () async{
                                if(await canLaunch(vl.value)){
                                  await launch(vl.value,
                                    forceWebView: false,
                                    forceSafariVC: false
                                  );
                                }
                              }
                            )
                            :TextSpan(
                              style: Theme.of(context).primaryTextTheme.body1,
                              text: vl.value
                           )
                        )
                        
                      );
                  }).toList(),
                )
              : Text(
                "-",
                style: Theme.of(context).primaryTextTheme.body1,
              )
            )
        ],
      ),
    );
  }
}