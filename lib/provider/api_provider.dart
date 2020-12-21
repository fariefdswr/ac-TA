import 'dart:convert';

import 'package:ac_app/model/temprature_model.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  Dio _dio;
  String _baseUrl = "http://acwemos.herokuapp.com/";

  ApiProvider() {
    BaseOptions options = BaseOptions(
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        },
        receiveTimeout: 1000000,
        connectTimeout: 1000000,
        baseUrl: _baseUrl,
        contentType: Headers.jsonContentType);

    _dio = Dio(options);

    _setupLoggingInterceptor();
  }

  void _setupLoggingInterceptor() {
    int maxCharactersPerLine = 200;
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("--> ${options.method} ${options.path}");
      print("Header: ${options.headers}");
      print("Content type: ${options.contentType}");
      print("Body: ${options.data}");
      print("<-- END HTTP");
      return options;
    }, onResponse: (Response response) {
      print(
          "<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
      String responseAsString = response.data.toString();
      if (responseAsString.length > maxCharactersPerLine) {
        int iterations =
            (responseAsString.length / maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          print(responseAsString.substring(
              i * maxCharactersPerLine, endingIndex));
        }
      } else {
        print(response.data);
      }
      print("<-- END HTTP");
    }, onError: (DioError error) {
      print(error);
    }));
  }

  String _handleError(error) {
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          errorDescription =
              "Received invalid status code: ${error.response.statusCode}";
          break;
        default:
          errorDescription = "Not Found Method";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured " + error.toString();
    }
    return errorDescription;
  }

  Future<TempratureModel> setDefaultTemprature(
      {Map<String, dynamic> body}) async {
    try {
      final response =
          await _dio.post("set_default_temprature", data: json.encode(body));
      return TempratureModel.fromJson(response.data);
    } catch (error, _) {
      return TempratureModel.withError(_handleError(error));
    }
  }

  Future<TempratureModel> getTemprature() async {
    try {
      final response = await _dio.post("get_all_temprature");
      return TempratureModel.fromJson(response.data);
    } catch (error, _) {
      return TempratureModel.withError(_handleError(error));
    }
  }
}
