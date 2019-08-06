import 'package:nerb/Models/Response/Geometry.dart';

import 'PlacePhoto.dart';

class DetailNearbyPlaceResponse{
  Geometry geometry;
  String icon;
  String id;
  String name;
  List<PlacePhoto> photos;
  String placeId;
  String reference;
  List<String> types;
  String vicinity;

  DetailNearbyPlaceResponse.fromJson(Map<String,dynamic> data){
    
    geometry = data['geometry'] != null ? Geometry.fromJson(data['geometry']) : null;
    icon = data['icon'];
    id = data['id'];
    name = data['name'];
    if(data['photos'] != null){
      photos = new List<PlacePhoto>();
      for(Map<String,dynamic> pt in data['photos']){
        photos.add(PlacePhoto.fromJson(pt));
      }
    }
    placeId = data['place_id'];
    reference = data['reference'];
    types = data['types'].cast<String>();
    vicinity = data['vicinity'];
  }

  DetailNearbyPlaceResponse.flag(String flag){
    id = flag;
  }

  Map<String,dynamic> getMap(){

    List<Map<String,dynamic>> mapPlaces = List();
    if(photos != null){
      photos.forEach((pt){
        mapPlaces.add(pt.getMap());
      });
    }
    return {
      'geometry' : geometry != null ? geometry.getMap() : null,
      'icon' : icon,
      'name' : name,
      'photos' : photos != null ? mapPlaces : null,
      'place_id' : placeId,
      'reference' : reference,
      'types' : types,
      'vicinity' : vicinity
    };
  }
}