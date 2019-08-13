import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';

class NearbyPlaceResponse {
  List<DetailNearbyPlaceResponse> nearbyPlaces;
  
  NearbyPlaceResponse.fromJson(Map<String,dynamic> data){
    if(data['results'] != null){
      if(data['results']['items'] != null){
        nearbyPlaces = List();
        for(Map<String,dynamic> res in data['results']['items']){
          nearbyPlaces.add(DetailNearbyPlaceResponse.fromJson(res));
        }
      }
    }
  }

  Map<String,dynamic> getMap(){
    List<Map<String,dynamic>> np;
    if(nearbyPlaces != null){
       np = new List();
       nearbyPlaces.forEach((p){
         np.add(p.getMap());
       });
    }
    return {
      'results' : np
    };
  }

  int get getLength => nearbyPlaces != null ? nearbyPlaces.length : 0;
}