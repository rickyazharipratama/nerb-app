import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:nerb/Collections/APICollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';

class NetworkHelper{

  static NetworkHelper instance(String lang) => NetworkHelper(lang);
  Dio dio;

  NetworkHelper(String lang){
    dio = Dio(BaseOptions(
      baseUrl: APICollections.instance.baseMapEndpoint,
      connectTimeout: ConstantCollections.Connectiontimeout,
      responseType: ResponseType.json,
      headers: {
        'Accept-Language' : lang
      }
    ));
  }

  Future<Response<Map<String,dynamic>>> requestGet({String path}) async{
    print(internalServerResponse());
    try{
      return dio.get(path);
    }catch(e){
       return Response(statusCode: 500, data: internalServerResponse(),statusMessage: ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR);
    }
  }


  String timeoutResopnse(){
    return json.encode({
      'html_attributions' : null,
      'results' : null,
      'status' : ConstantCollections.RESPONSE_TIMEOUT,
      'error_message': ConstantCollections.RESPONSE_TIMEOUT
    });
  }

  Map<String,dynamic> internalServerResponse(){
    return {
      'html_attributions' : null,
      'results' : null,
      'status' : ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR,
      'error_message': ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR
    };
  }

}