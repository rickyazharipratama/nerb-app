import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/DistanceHelper.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/misc/Separator.dart';

class BottomDetailPlaces extends StatelessWidget  {

  final double currentOffsetPercent;
  final ValueChanged<bool> animate;
  final ValueChanged<DragUpdateDetails> onVerticalDrugUpdate;
  final VoidCallback panDown;
  final bool isOpen;
  final DetailNearbyPlaceResponse place;

  BottomDetailPlaces({@required this.isOpen, @required this.currentOffsetPercent, @required this.animate, @required this.onVerticalDrugUpdate, @required this.panDown, @required this.place});


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
    return  ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,  
      children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).highlightColor
                  ),
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: place.icon,
                      alignment: Alignment.center,
                      color: Theme.of(context).buttonColor,
                      colorBlendMode: BlendMode.srcIn,
                      errorWidget: (context,_,__)=> Icon(
                        Icons.location_on,
                        size: 25,
                        color: Theme.of(context).buttonColor,
                      ),
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      placeholder: (context,_) => Icon(
                        Icons.location_on,
                        size: 20,
                        color: Theme.of(context).buttonColor
                      ),
                    )
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      place.title,
                      style: Theme.of(context).primaryTextTheme.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Separator(),
          ),

          Padding(
            padding: const EdgeInsets.only(top : 10, bottom : 10, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                  badge(context,
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: Icons.directions,
                    val: DistanceHelper.instance.getFormatDistance(context, (place.distance.toDouble()/1000)),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 10,left: 10, right: 10, bottom: 10),
                    child: Center(
                      child: Container(
                        width: 1,
                        height: 50,
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                  ),

                  Expanded(
                    child: badge(context,
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      icon: Icons.room,
                      val: place.vicinity.replaceAll("<br/>", "\n")
                    ),
                  )
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Separator(),
          ),
       ],
    );
  }


  Widget badge(BuildContext context,{ EdgeInsets padding, IconData icon, String val}){
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).highlightColor
            ),
            child: Center(
              child: Icon(
                icon,
                color: Theme.of(context).buttonColor,
                size: 25, 
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              val,
              style: Theme.of(context).primaryTextTheme.body1,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )       
        ],
      ),
    );
  }
}