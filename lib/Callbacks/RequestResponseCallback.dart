


import 'package:dio/dio.dart';

enum RequestResponseState{onSuccessResponseSuccess, onSuccessResponseFailed, onFailureWithResponse, onfailure}

abstract class RequestResponseCallback{

  onSuccessResponseSuccess(Map<String,dynamic> data);

  onSuccessResponseFailed(Response data);

  onFailureWithResponse(Response res);

  onfailure();

}