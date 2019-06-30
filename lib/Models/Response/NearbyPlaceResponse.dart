import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';

class NearbyPlaceResponse {
  List<String> htmlAttributions;
  List<DetailNearbyPlaceResponse> nearbyPlaces;
  String status;
  String errorMessages;
  String nextPageToken;
  
  NearbyPlaceResponse.fromJson(Map<String,dynamic> data){
    htmlAttributions = data['html_attributions'] != null ? data['html_attributions'].cast<String>() : null;
    if(data['results'] != null){
      nearbyPlaces = new List();
      for(Map<String,dynamic> res in data['results']){
        nearbyPlaces.add(DetailNearbyPlaceResponse.fromJson(res));
      }
      
    }
    status = data['status'];
    errorMessages = data['error_message'];
    nextPageToken = data['next_page_token'];
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
      'html_attributions' : htmlAttributions,
      'results' : np,
      'status' : status,
      'error_message' : errorMessages,
      'next_page_token' : nextPageToken
    };
  }
}