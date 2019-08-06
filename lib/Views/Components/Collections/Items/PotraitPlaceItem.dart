import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/APICollections.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';

class PotraitPlaceItem extends StatelessWidget {

  final DetailNearbyPlaceResponse place;
  final double blur;
  final double offset;
  final double top;

  PotraitPlaceItem({@required this.place, this.blur : 0, this.offset : 0, this.top : 0});

  @override
  Widget build(BuildContext context) {
    print(jsonEncode(place.getMap()));
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: EdgeInsets.fromLTRB(0, top, 30, 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: blur,
            offset: Offset(offset,offset)
          )
        ]
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: place.photos != null ? APICollections.instance.baseMapEndpoint+APICollections.instance.apiPlacePhoto(
                photoReference: place.photos[0].photoReference,
                maxWidth: 400
              ) : "",
              fit: BoxFit.cover,
              color: ColorCollections.wrapperCategory,
              colorBlendMode: BlendMode.srcATop,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              placeholder: (context,_){
                if(CommonHelper.instance.getPlaceImagebyIconName(icon: place.icon) != null){
                  return Image.asset(
                    CommonHelper.instance.getPlaceImagebyIconName(icon: place.icon),
                    width: 159,
                    height: 200,
                    fit: BoxFit.cover,
                    color: ColorCollections.wrapperCategory,
                    colorBlendMode: BlendMode.srcATop,
                  );
                }
                return ImagePlaceholder();
              },
              errorWidget: (context,_,__){
                if(CommonHelper.instance.getPlaceImagebyIconName(icon: place.icon) != null){
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.asset(
                          CommonHelper.instance.getPlaceImagebyIconName(icon: place.icon),
                          width: 159,
                          height: 200,
                          fit: BoxFit.cover,
                          color: ColorCollections.wrapperCategory,
                          colorBlendMode: BlendMode.srcATop,
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
                return ImagePlaceholder();
              },
            )
          )
        ],
      ),
    );
  }
}