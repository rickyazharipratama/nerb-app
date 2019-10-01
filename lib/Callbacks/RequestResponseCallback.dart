


import 'package:dio/dio.dart';

enum RequestResponseState{onSuccessResponseSuccess, onSuccessResponseFailed, onFailureWithResponse, onfailure}

abstract class RequestResponseCallback{

  void onSuccessResponseSuccess(Map<String,dynamic> data);

  void onSuccessResponseFailed(Response data);

  void onFailureWithResponse(Response res);

  void onfailure();

}