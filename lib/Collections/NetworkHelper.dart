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
    ));
  }

  Future<Response<Map<String,dynamic>>> requestGet({String path}) async{
    print(path);
    try{
      return dio.get(path);
    }catch(e){
       return Response(statusCode: 500, data: internalServerResponse(),statusMessage: ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR);
    }
  }


  String timeoutResopnse(){
    return json.encode({
      'status':'FAILED',
      'desc':'timeout'
    });
  }

  Map<String,dynamic> internalServerResponse(){
    return {
      'status':'FAILED',
      'desc':'internal Server error'
    };
  }

}