import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:nerb/Collections/APICollections.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/DistanceHelper.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';

class DetailPlace extends StatefulWidget {

  final DetailNearbyPlaceResponse place;
  final double mode;

  DetailPlace({@required this.place, this.mode:0});

  @override
  _DetailPlaceState createState() => new _DetailPlaceState();
}

class _DetailPlaceState extends State<DetailPlace> {

  double distance = 0;
  LocationData myLoc;


  @override
  void initState() {
    super.initState();
    initiateData();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.width * 9 / 16 ) +70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: widget.place.photos != null ? CachedNetworkImage(
                imageUrl: APICollections.instance.baseMapEndpoint
                  +APICollections.instance.apiPlacePhoto(
                    maxWidth: MediaQuery.of(context).size.width.toInt(),
                    photoReference: widget.place.photos[0].photoReference
                  ),
                
                height: widget. mode == 0 ?((MediaQuery.of(context).size.width - 20) * 9) / 16 : (((MediaQuery.of(context).size.width - 25)/2)*9)/16,
                width:  widget.mode == 0 ? MediaQuery.of(context).size.width - 20 : (MediaQuery.of(context).size.width - 25) / 2,
                fit: BoxFit.cover,
                color: ColorCollections.wrapperCategory,
                colorBlendMode: BlendMode.srcATop,
                placeholder: (context,_){
                  if(CommonHelper.instance.getPlaceImagebyIconName(icon: widget.place.icon) != null){
                    return Image.asset(
                      CommonHelper.instance.getPlaceImagebyIconName(icon: widget.place.icon),
                      height: widget.mode == 0 ? ((MediaQuery.of(context).size.width - 20) * 9) / 16 : (((MediaQuery.of(context).size.width - 25)/2)*9)/16,
                      width: widget.mode == 0 ? ((MediaQuery.of(context).size.width - 20)) : ((MediaQuery.of(context).size.width - 25) / 2),
                      fit: BoxFit.cover
                    );
                  }
                  return Container(
                    width: widget.mode == 0 ? MediaQuery.of(context).size.width - 20 : (MediaQuery.of(context).size.width - 25) / 2,
                    height: widget.mode == 0 ? ((MediaQuery.of(context).size.width -20) * 9) / 16: (((MediaQuery.of(context).size.width - 25) / 2) * 9) / 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).highlightColor
                    ),
                    child: ImagePlaceholder(),
                  );
                },
                errorWidget: (context,_,__){
                  if(CommonHelper.instance.getPlaceImagebyIconName(icon: widget.place.icon) != null){
                    return Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Image.asset(
                            CommonHelper.instance.getPlaceImagebyIconName(icon: widget.place.icon),
                            height: widget.mode == 0 ? ((MediaQuery.of(context).size.width - 20) * 9) / 16 : (((MediaQuery.of(context).size.width - 25) / 2) * 9) / 16,
                            width: widget.mode == 0 ? (MediaQuery.of(context).size.width -20) : ((MediaQuery.of(context).size.width - 25) / 2),
                            fit: BoxFit.cover,
                          ),
                        ),

                        Positioned.fill(
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 45,
                              color: ColorCollections.blenBrokenImage,
                            )
                          ),
                        ),
                      ],
                    );
                  }
                  return Container(
                    width: widget.mode == 0 ? MediaQuery.of(context).size.width - 20 : (MediaQuery.of(context).size.width - 25) / 2,
                    height: widget.mode == 0 ? ((MediaQuery.of(context).size.width -20) * 9) / 16: (((MediaQuery.of(context).size.width - 25) / 2) * 9) / 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).highlightColor
                    ),
                    child: ImagePlaceholder(),
                  );
                },
              )
              : Container(
                  width: widget.mode == 0 ? MediaQuery.of(context).size.width - 20 : (MediaQuery.of(context).size.width - 25) / 2,
                  height: widget.mode == 0 ? ((MediaQuery.of(context).size.width -20) * 9) / 16: (((MediaQuery.of(context).size.width - 25) / 2) * 9) / 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).highlightColor
                  ),
                  child: ImagePlaceholder(),
                ),
            ),
          ),
          
          Container(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                  child: Text(
                    widget.place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).primaryTextTheme.subhead,
                  ),
                ),
                Row(
                  children: <Widget>[
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

                    Text(
                      DistanceHelper.instance.getFormatDistance(context, distance),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).primaryTextTheme.body1,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  initiateData() async{
    Location loc = Location();
    try{
      myLoc = await loc.getLocation();
      if(mounted){
        setState(() {
          distance = DistanceHelper.instance.getDistance(
            fromLat: myLoc.latitude,
            fromLong: myLoc.longitude,
            toLat: double.parse(widget.place.geometry.location.latitude),
            toLong: double.parse(widget.place.geometry.location.longitude)
          );
        });
      }
    } on PlatformException catch(e){
      print("error : "+e.code);
    }

  }
}