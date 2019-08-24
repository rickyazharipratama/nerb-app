import 'package:nerb/Models/Response/CategoryPlaceResponse.dart';

class DetailNearbyPlaceResponse{
  
  List<double> position;
  int distance;
  String title;
  double averageRating;
  CategoryPlaceResponse category;
  String icon;
  String vicinity;
  String type;
  String href;
  String id;
  List<String> chainId;

  DetailNearbyPlaceResponse.fromJson(Map<String,dynamic> data){
     if(data['position'] != null){
       position = List();
       for(dynamic dt in data['position']){
          position.add(double.parse(dt.toString()));
       }
     }
     distance = data['distance'] != null ? int.parse(data['distance'].toString()) : -1;
     title = data['title'];
     averageRating = data['averageRating'] != null ? double.parse(data['averageRating'].toString()) : 0;
     category = data['category'] != null ? CategoryPlaceResponse.fromJson(data['category']) : null;
     icon = data['icon'];
     vicinity = data['vicinity'] != null  ? data['vicinity'].toString().replaceAll("<br/>", "\n") : null;
     type= data['type'];
     href = data['href'] != null ? Uri.encodeComponent(data['href']) : null;
     id = data['id'];
     if(data['chainIds'] != null){
       chainId = List();
       for(String id in data['chainIds']){
         chainId.add(id);
       }
     }
  }

  Map<String,dynamic> getMap(){
    return {
      'position'  : position,
      'distance'  : distance,
      'title'     : title,
      'averageRating' : averageRating,
      'category' : category != null ? category.getMap() : null,
      'icon' : icon,
      'vicinity'  : vicinity,
      'type' : type,
      'href' : href,
      'id' : id,
      'chainIds' : chainId
    };
  }
}