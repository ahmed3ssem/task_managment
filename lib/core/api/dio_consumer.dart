import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_project_structure/core/api/status_code.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../error/exceptions.dart';
import 'api_consumer.dart';
import 'app_interceptor.dart';
import 'end_points.dart';
import 'package:flutter_project_structure/injection_container.dart' as di;

class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    (client.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
          dioClient.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return dioClient;
        };
    client.options
      ..baseUrl = EndPoints.devUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..connectTimeout = const Duration(seconds: 60)
      ..receiveTimeout = const Duration(seconds: 60)
      ..validateStatus = (status) {
        return status! < StatusCode.internalServerError;
      };
    client.interceptors.add(di.sl<AppInterceptor>());
    client.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
      ),
    );
  }

  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await client.get(path, queryParameters: queryParams);
      return handleResponseAsJson(response);
    } on DioException catch (error) {
      handleDioError(error);
    }
  }

  @override
  Future post(
    String path, {
    Map<String, dynamic>? queryParams,
    body,
    bool isFormData = false,
  }) async {
    try {
      final response = await client.post(
        path,
        queryParameters: queryParams,
        data: isFormData ? FormData.fromMap(body!) : body,
      );
      return handleResponseAsJson(response);
    } on DioException catch (error) {
      handleDioError(error);
    }
  }

  @override
  Future put(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    bool isFormData = false,
  }) async {
    try {
      final response = await client.put(
        path,
        queryParameters: queryParams,
        data: isFormData ? FormData.fromMap(body!) : body,
      );
      return handleResponseAsJson(response);
    } on DioException catch (error) {
      handleDioError(error);
    }
  }

  dynamic handleResponseAsJson(Response<dynamic> response) {
    final responseJson = jsonDecode(response.data.toString());
    return {'data': responseJson, 'statusCode': response.statusCode};
  }

  dynamic handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.badCertificate:
        throw const BadCertificateException();
      case DioExceptionType.badResponse:
        throw const BadResponseException();
      case DioExceptionType.connectionError:
        throw const ConnectionErrorException();
      case DioExceptionType.unknown:
        throw const UnknownDioErrorException();
    }
    switch (error.response?.statusCode) {
      case StatusCode.badRequest:
        throw const BadRequestException();
      case StatusCode.unauthorized:
      case StatusCode.forBidden:
        throw const UnauthorizedException();
      case StatusCode.notFound:
        throw const NotFoundException();
      case StatusCode.conflict:
        throw const ConflictException();
      case StatusCode.internalServerError:
        throw const InternalServerErrorException();
      default:
        throw const BadResponseException(); // Add a default case for unhandled response codes
    }
  }
}
