import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/APICollections.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/misc/NerbCacheImage.dart';

class PlaceNearYouItem extends StatelessWidget {

  final DetailNearbyPlaceResponse place;
  PlaceNearYouItem({this.place});

  @override
  Widget build(BuildContext context) {
    print(place.icon);
    return Container(
      width: 180,
      height: 230,
      margin: const EdgeInsets.only(left : 10, right : 10),
      child : Material(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(5),
        elevation: 2,
        shadowColor: ColorCollections.shimmerHighlightColor,
        child: Stack(
          children: <Widget>[
              Positioned.fill(
                child: Hero(
                  tag: "image-"+place.id,
                  child: NerbCacheImage(
                    radius: 5,
                    height: 150,
                    width: 200,
                    placeholder: CommonHelper.instance.getPlaceImagebyIconName(icon: place.icon) != null ?
                      CommonHelper.instance.getPlaceImagebyIconName(icon: place.icon)
                      : null
                    ,
                    url: place.photos != null ?
                      APICollections.instance.baseMapEndpoint + APICollections.instance.apiPlacePhoto(
                        photoReference: place.photos[0].photoReference,
                        maxWidth: 400
                      )
                      :null
                    ,
                  ),
                )
              ),

              Positioned(
               left: 0,
               top: 0,
               child: Padding(
                 padding: const EdgeInsets.only(left: 10, top: 10),
                 child: Container(
                   width: 30,
                   height: 30,
                   decoration: BoxDecoration(
                     color: ColorCollections.wrapCategoryIcon,
                     borderRadius: BorderRadius.circular(15)
                   ),
                   child: Center(
                    child: CachedNetworkImage(
                      imageUrl: place.icon,
                      alignment: Alignment.center,
                      color: ColorCollections.titleColor,
                      colorBlendMode: BlendMode.srcIn,
                      errorWidget: (context,_,__)=> Icon(
                        Icons.location_on,
                        size: 20,
                        color: ColorCollections.titleColor,
                      ),
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      placeholder: (context,_) => Icon(
                        Icons.location_on,
                        size: 20,
                        color: ColorCollections.titleColor,
                      ),
                     )
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline
                  ),
                ),
              )

          ],
        ),
      ),
    );
  }
}