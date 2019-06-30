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

  Map<String,dynamic> getMap(){
    List<Map<String,dynamic>> mapPlaces = List();
    photos.forEach((pt){
      mapPlaces.add(pt.getMap());
    });
    return {
      'geometry' : geometry.getMap(),
      'icon' : icon,
      'name' : name,
      'photos' : mapPlaces,
      'place_id' : placeId,
      'reference' : reference,
      'types' : types,
      'vicinity' : vicinity
    };
  }

}