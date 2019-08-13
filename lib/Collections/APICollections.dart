class APICollections{

  
  String baseMapEndpoint = "https://places.api.here.com";

  static APICollections instance = APICollections();

  String apiNearbyPlace({String type, String location, String radius, String language}){
    return "//places/v1/discover/around?app_id=cC7Yc8UZEBc0Drx2bm20&app_code=hTOfsIl-hja0IbsqkvrHng"
      +"&in="+location+";r="+radius;
  }
}