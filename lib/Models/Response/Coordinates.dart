class Coordinates{

  String latitude;
  String longitude;

  Coordinates.fromJson(Map<String,dynamic> data){
    latitude = data['lat'] != null ? data['lat'].toString() : "";
    longitude = data['lng'] != null ? data['lng'].toString() :"";
  }

  Map<String,dynamic> getMap(){
    return {
      'lat' : latitude,
      'lng' : longitude
    };
  }

}