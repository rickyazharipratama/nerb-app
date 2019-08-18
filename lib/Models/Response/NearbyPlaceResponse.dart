import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';

class NearbyPlaceResponse {
  List<DetailNearbyPlaceResponse> nearbyPlaces;
  
  int _lastFetch;

  set setLastFetch(int val) => _lastFetch = val;
  int get lastFetch => _lastFetch;

  NearbyPlaceResponse.fromJson(Map<String,dynamic> data){
    if(data['results'] != null){
      if(data['results']['items'] != null){
        nearbyPlaces = List();
        for(Map<String,dynamic> res in data['results']['items']){
          nearbyPlaces.add(DetailNearbyPlaceResponse.fromJson(res));
        }
      }
    }
    if(data['lastFetch'] != null){
      _lastFetch = int.parse(data['lastFetch'].toString());
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
      'results' : {
        'items' : np
      },
      'lastFetch': _lastFetch
    };
  }

  int get getLength => nearbyPlaces != null ? nearbyPlaces.length : 0;
}