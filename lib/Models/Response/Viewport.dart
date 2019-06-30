import 'package:nerb/Models/Response/Coordinates.dart';

class Viewport{

  Coordinates northeast;
  Coordinates southWest;

  Viewport.fromJson(Map<String,dynamic> data){
    northeast = data['northeast'] != null ? Coordinates.fromJson(data['northeast']) : null;
    southWest = data['southwest'] != null ? Coordinates.fromJson(data['southwest']) : null;
  }

  Map<String,dynamic> getMap(){
    return {
      'northeast' : northeast.getMap(),
      'southwest' : southWest.getMap()
    };
  }


}