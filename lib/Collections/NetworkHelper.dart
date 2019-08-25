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
      receiveTimeout: ConstantCollections.Connectiontimeout,
      responseType: ResponseType.json,
      receiveDataWhenStatusError: true,
    ));
  }

  Future<Response<Map<String,dynamic>>> requestGet({String path}) async{
    print(path);
    try{
      return await dio.get(path);
    }on DioError catch(e){
      print("network error : " + e.type.toString());
      if(e.type == DioErrorType.RESPONSE){
        return Response(statusCode: e.response.statusCode, data: e.response.data, statusMessage:  e.response.statusMessage);
      }else if(e.type == DioErrorType.CONNECT_TIMEOUT
      || e.type == DioErrorType.SEND_TIMEOUT
      || e.type == DioErrorType.RECEIVE_TIMEOUT){
        return checkExternalRequest();
      }
      return  Response(statusCode: 500, data: internalServerResponse(),statusMessage: ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR);
    }
  }

  Response checkExternalRequest() {
    try{
      Response res;
      dio.get("https://google.com")
      .then((res){
        res = Response(statusCode:504, data: timeoutResopnse(), statusMessage: ConstantCollections.RESPONSE_TIMEOUT);
      });
      return res;
    }on DioError catch(e){
      if(e.type == DioErrorType.RESPONSE){
        return Response(statusCode: e.response.statusCode, data: e.response.data, statusMessage: e.response.statusMessage);
      }else if(e.type == DioErrorType.CONNECT_TIMEOUT
      || e.type == DioErrorType.SEND_TIMEOUT
      || e.type == DioErrorType.RECEIVE_TIMEOUT){
        return Response(statusCode: 408, data: timeoutResopnse(), statusMessage: ConstantCollections.RESPONSE_TIMEOUT);
      }
      return  Response(statusCode: 500, data: internalServerResponse(),statusMessage: ConstantCollections.RESPONSE_INTERNAL_SERVER_ERROR);
    }
  }

  String timeoutResopnse(){
    return json.encode({
      'status':'FAILED',
      'desc':'timeout',
      'code':'timeout'
    });
  }



  Map<String,dynamic> internalServerResponse(){
    return {
      'status':'FAILED',
      'desc':'internal Server error',
      'code':'internal_server_error'
    };
  }

}