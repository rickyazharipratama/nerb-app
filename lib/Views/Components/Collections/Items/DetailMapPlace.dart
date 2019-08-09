import 'package:flutter/material.dart';
import 'package:nerb/Collections/APICollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/misc/NerbCacheImage.dart';

class DetailMapPlace extends StatelessWidget {

  final ValueChanged<DetailNearbyPlaceResponse> callback;
  final bool isActive;
  final DetailNearbyPlaceResponse place;

  DetailMapPlace({@required this.callback, this.isActive : false, @required this.place});
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        callback(place);
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.all(5),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        width: (150 * 11)/ 16,
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isActive ?  Colors.black87 : Colors.black12,
              blurRadius: isActive ? 5 : 2,
              offset: isActive ? Offset(0,0.5) : Offset(0,0)
            )
          ]
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: NerbCacheImage(
                width: (150 * 11)/ 16,
                height: 150,
                placeholder: CommonHelper.instance.getPlaceImagebyIconName(icon: place.icon) != null ?
                      CommonHelper.instance.getPlaceImagebyIconName(icon: place.icon)
                      : null,
                radius: 10,
                url: place.photos != null ?
                  APICollections.instance.baseMapEndpoint + APICollections.instance.apiPlacePhoto(
                    photoReference: place.photos[0].photoReference,
                    maxWidth: 400
                  )
                  :null,
              ),
            )

          ],
        ),
      ),
    );
  }
}