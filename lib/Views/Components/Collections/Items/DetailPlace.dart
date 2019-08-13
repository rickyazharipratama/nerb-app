import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/DistanceHelper.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/misc/NerbCacheImage.dart';

class DetailPlace extends StatefulWidget {

  final DetailNearbyPlaceResponse place;
  final double mode;

  DetailPlace({@required this.place, this.mode:0});

  @override
  _DetailPlaceState createState() => new _DetailPlaceState();
}

class _DetailPlaceState extends State<DetailPlace> {

  LocationData myLoc;


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.mode == 0 ? ((MediaQuery.of(context).size.width - 20) * 9 / 16 ) +80
      : ((((MediaQuery.of(context).size.width - 25) / 2) * 16) / 9) + 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          Expanded(
            child: Hero(
              tag: "image-"+widget.place.id,
              child: NerbCacheImage(
                height: widget.mode == 0 ? ((MediaQuery.of(context).size.width - 20) * 9) / 16 : (((MediaQuery.of(context).size.width - 25)/2)*16)/9,
                width: widget.mode == 0 ? MediaQuery.of(context).size.width - 20 : (MediaQuery.of(context).size.width - 25) / 2,
                placeholder: CommonHelper.instance.getPlaceImageByCategory(
                  category: widget.place.category.title
                ) != null ? 
                  CommonHelper.instance.getPlaceImagebyIconName(icon: widget.place.icon)
                :null,
                url: null
              ),
            ),
          ),
          
          Container(
            height: widget.mode == 0  ? 80 : 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                  child: Text(
                    widget.place.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).primaryTextTheme.subhead,
                  ),
                ),

                placeDescription(context)
                
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget placeDescription(context){
    return widget.mode == 0 ? Row(
      children: <Widget>[
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.room,
                color: Theme.of(context).buttonColor,
                size: 25, 
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    widget.place.vicinity,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).primaryTextTheme.body1,
                  ),
                ),
              ),
            ],
          )
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.directions,
              color: Theme.of(context).buttonColor,
              size: 25, 
            ),

            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                DistanceHelper.instance.getFormatDistance(context, widget.place.distance.toDouble()),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).primaryTextTheme.body1,
              ),
            )
          ],
        )
      ],
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.room,
              color: Theme.of(context).buttonColor,
              size: 25, 
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  widget.place.vicinity,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).primaryTextTheme.body1,
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.directions,
              color: Theme.of(context).buttonColor,
              size: 25, 
            ),

            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                DistanceHelper.instance.getFormatDistance(context, widget.place.distance.toDouble()),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).primaryTextTheme.body1,
              ),
            )
          ],
        )
      ],
    );
  }
}