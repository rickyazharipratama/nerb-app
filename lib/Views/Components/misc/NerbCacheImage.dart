import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';

class NerbCacheImage extends StatelessWidget {

  final String url;
  final String placeholder;
  final double width;
  final double height;
  final double radius;

  NerbCacheImage({this.url, this.placeholder, @required this.width, @required this.height, this.radius : 10});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url != null ?
        CachedNetworkImage(
          imageUrl: url,
          height: height,
          width: width,
          fit: BoxFit.cover,
          color: ColorCollections.wrapperCategory,
          colorBlendMode: BlendMode.srcATop,
          placeholder: (context, _) => errorPlaceholder(context),
          errorWidget: (context,_,__) => errorPlaceholder(context),
        )
      : errorPlaceholder(context)
    );
  }

  Widget errorPlaceholder(context){
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: placeholder != null ?
            Image.asset(
              placeholder,
              width: width,
              height: height,
              fit: BoxFit.cover,
            )
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).highlightColor
              ),
              child: ImagePlaceholder(),
            ),
          ),

        Positioned.fill(
          child: placeholder != null ?
            Center(
              child: Icon(
                Icons.broken_image,
                size: 45,
                color: ColorCollections.blenBrokenImage,
              ),
            )
          : Container(),
        )
      ],
    );
  }
}