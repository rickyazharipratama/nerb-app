


import 'package:dio/dio.dart';

abstract class RequestResponseCallback{

  onSuccessResponseSuccess(Map<String,dynamic> data);

  onSuccessResponseFailed(Map<String,dynamic> data);

  onFailureWithResponse(Response res);

  onfailure();
}