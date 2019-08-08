class APICollections{

  String _apiKey = "AIzaSyCrQR6LC62OwsSAkOXMqNZ1Z_E3fLagJ0M";
  String baseMapEndpoint = "https://maps.googleapis.com/maps/api";

  static APICollections instance = APICollections();

  String apiNearbyPlace({String type , String pageToken, String location, String radius, String language}){
    return "/place/nearbysearch/json?key="
      +_apiKey
      +(type != null ?"&type="+type : "")
      +"&location="+location
      +"&radius="+radius
      +(language != null ? "&language="+language : "")
      +(pageToken != null ? "&pagetoken="+pageToken : "");
  }

  String apiPlacePhoto({String photoReference, int maxWidth}){
    return "/place/photo?key="
      +_apiKey
      +"&photoreference="+photoReference
      +"&maxwidth="+maxWidth.toString();
  }

}