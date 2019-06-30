import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/APICollections.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';

class PlaceNearYouItem extends StatelessWidget {

  final DetailNearbyPlaceResponse place;
  PlaceNearYouItem({this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 179,
      height: 200,
      margin: const EdgeInsets.only(left : 10, right : 10),
      child : Material(
        color: ColorCollections.shimmerBaseColor,
        borderRadius: BorderRadius.circular(5),
        elevation: 2,
        shadowColor: ColorCollections.shimmerHighlightColor,
        child: Stack(
          children: <Widget>[
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: place.photos != null ?
                    CachedNetworkImage(
                      imageUrl: APICollections.instance.baseMapEndpoint+APICollections.instance.apiPlacePhoto(
                        photoReference: place.photos[0].photoReference,
                        maxWidth: 150
                      ),
                      color: ColorCollections.wrapperCategory,
                      colorBlendMode: BlendMode.srcATop,
                      fit: BoxFit.cover,
                      width: 159,
                      height: 200,
                      placeholder: (context,_)=> ImagePlaceholder(),
                      errorWidget: (context,_,__) => ImagePlaceholder(),
                  ) : ImagePlaceholder(),
                ),
              )
          ],
        ),
      ),
    );
  }
}