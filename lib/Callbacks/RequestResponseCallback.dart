


import 'package:dio/dio.dart';

enum RequestResponseState{onSuccessResponseSuccess, onSuccessResponseFailed, onFailureWithResponse, onfailure}

abstract class RequestResponseCallback{

  onSuccessResponseSuccess(Map<String,dynamic> data);

  onSuccessResponseFailed(Map<String,dynamic> data);

  onFailureWithResponse(Response res);

  onfailure();

}