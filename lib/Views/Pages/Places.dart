import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/APICollections.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Collections/Items/PotraitPlaceItem.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';
import 'package:nerb/Views/Components/misc/NerbPushAppBar.dart';

class Places extends StatefulWidget {

  final String title;
  final List<DetailNearbyPlaceResponse> places;
  final String nextToken;

  Places({@required this.title, this.places, this.nextToken});

  @override
  _PlacesState createState() => new _PlacesState();
}

class _PlacesState extends State<Places> {

  List<DetailNearbyPlaceResponse>places;
  int activeIndex = 0;
  String nextToken;

  PageController listController;

  @override
  void initState() {
    super.initState();
    listController = PageController(initialPage: activeIndex, viewportFraction: 0.8);
    if(widget.nextToken != null){
      this.nextToken = widget.nextToken;
    }
    if(widget.places != null){
      this.places = List();
      this.places.addAll(widget.places);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: places[activeIndex].photos != null ? APICollections.instance.baseMapEndpoint+APICollections.instance.apiPlacePhoto(
                photoReference: places[activeIndex].photos[0].photoReference,
                maxWidth: 400
              ) : "",
              fit: BoxFit.cover,
              color: ColorCollections.wrapperCategory,
              colorBlendMode: BlendMode.srcATop,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              placeholder: (context,_){
                if(CommonHelper.instance.getPlaceImagebyIconName(icon: places[activeIndex].icon) != null){
                  return Image.asset(
                    CommonHelper.instance.getPlaceImagebyIconName(icon: places[activeIndex].icon),
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
                if(CommonHelper.instance.getPlaceImagebyIconName(icon: places[activeIndex].icon) != null){
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.asset(
                          CommonHelper.instance.getPlaceImagebyIconName(icon: places[activeIndex].icon),
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
          ),

          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    NerbPushAppBar(
                      title: widget.title,
                    ),

                    Expanded(
                      child: PageView.builder(
                        controller: listController,
                        itemCount: places.length,
                        itemBuilder: (context,idx){
                          return PotraitPlaceItem(
                            place: places[idx],
                            blur: activeIndex == idx ? 30 : 0,
                            offset: activeIndex == idx ? 20 : 0,
                            top: activeIndex == idx ? 10 : 50,
                          );
                        },
                        onPageChanged: (active){
                          if(mounted){
                            setState(() {
                              activeIndex = active;
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}