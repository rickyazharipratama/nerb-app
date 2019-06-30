class APICollections{

  String _apiKey = "AIzaSyC9cbFzf3a4_Z6gwkSE-tXW8WDtQQ8dR08";
  String baseMapEndpoint = "https://maps.googleapis.com/maps/api";

  static APICollections instance = APICollections();

  String apiNearbyPlace({String type , String pageToken, String location, String radius}){
    return "/place/nearbysearch/json?key="
      +_apiKey
      +(type != null ?"&type="+type : "")
      +"&location="+location
      +"&radius="+radius
      +(pageToken != null ? "&pagetoken="+pageToken : "");
  }

  String apiPlacePhoto({String photoReference, int maxWidth}){
    return "/place/photo?key="
      +_apiKey
      +"&photoreference="+photoReference
      +"&maxwidth="+maxWidth.toString();
  }

}