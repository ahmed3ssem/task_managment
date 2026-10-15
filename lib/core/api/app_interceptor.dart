import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../config/PrefHelper/prefs.dart';
import '../utils/app_strings.dart';

class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    Map<String, dynamic> headers = {};
    headers = getHeaders();
    options.headers = headers;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }

  Map<String, dynamic> getHeaders() {
    String token = '';
    Map<String, dynamic> header = {};
    if (Prefs.isContain(AppStrings.token)) {
      token = Prefs.getString(AppStrings.token);
      header = {'Authorization': 'Bearer $token'};
    }
    return header;
  }
}
