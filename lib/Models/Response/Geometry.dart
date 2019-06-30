import 'package:nerb/Models/Response/Coordinates.dart';
import 'package:nerb/Models/Response/Viewport.dart';

class Geometry{
  Coordinates location;
  Viewport viewport;

  Geometry.fromJson(Map<String,dynamic> data){
      location = data['location'] != null ? Coordinates.fromJson(data['location']) : null;
      viewport = data['viewport'] != null ? Viewport.fromJson(data['viewport']) : null;
  }

  Map<String,dynamic> getMap(){
    return{
      'location' : location.getMap(),
      'viewport' : viewport.getMap()
    };
  }
}