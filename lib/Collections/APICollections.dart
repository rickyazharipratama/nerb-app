import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/PreferenceHelper.dart';

class APICollections{

  
  String baseMapEndpoint = "https://places.api.here.com";

  static APICollections instance = APICollections();


  Future<String> apiNearbyPlace({String type, String location, String radius, String language}) async{
    String appCode = await PreferenceHelper.instance.getSecureStorage(
      key: ConstantCollections.PREF_APP_CODE
    );

    String appId = await PreferenceHelper.instance.getSecureStorage(
      key: ConstantCollections.PREF_APP_ID
    );
    print("appCode : "+appCode);
    print("appId :"+appId);
    return "//places/v1/discover/around?app_id="+appId+"&app_code="+appCode
      +"&in="+location+";r="+radius;
  }

}