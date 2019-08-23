import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';

class NearbyPlaceResponse {
  List<DetailNearbyPlaceResponse> nearbyPlaces;
  
  int _lastFetch;

  set setLastFetch(int val) => _lastFetch = val;
  int get lastFetch => _lastFetch;
  String next;

  NearbyPlaceResponse.fromJson(Map<String,dynamic> data){
    if(data['results'] != null){
      if(data['results']['items'] != null){
        nearbyPlaces = List();
        for(Map<String,dynamic> res in data['results']['items']){
          nearbyPlaces.add(DetailNearbyPlaceResponse.fromJson(res));
        }
      }
      next = data['results']['next'] != null ? Uri.encodeComponent(data['results']['next']) : null; 
    }
    if(data['lastFetch'] != null){
      _lastFetch = int.parse(data['lastFetch'].toString());
    }
  }

  NearbyPlaceResponse.fromNextResponse(Map<String,dynamic> data){
    if(data['items'] != null){
      nearbyPlaces = List();
      for(Map<String,dynamic> res in data['items']){
          nearbyPlaces.add(DetailNearbyPlaceResponse.fromJson(res));
        }
    }
    next = data['next'] != null ? Uri.encodeComponent(data['next']) : null; 
    if(data['lastFetch'] != null){
      _lastFetch = int.parse(data['lastFetch'].toString());
    }
  }

  List<DetailNearbyPlaceResponse>  get getNearbyPlaces => nearbyPlaces;
  set setNearbyPlace(List<DetailNearbyPlaceResponse> plc){
    if(nearbyPlaces == null){
      nearbyPlaces = List();
    }
    nearbyPlaces.addAll(plc);
  }

  String get getNext => next;
  set setNext(String nxt){
    next = nxt;
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
        'items' : np,
        'next' : next
      },
      'lastFetch': _lastFetch
    };
  }

  int get getLength => nearbyPlaces != null ? nearbyPlaces.length : 0;
}