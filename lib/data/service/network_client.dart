import 'dart:convert';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? data;
  final String errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.errorMessage = 'Something went wrong',
  });
}

class NetworkClient {
  static final Logger _logger = Logger();
  // static Future<NetworkResponse> getRequest({required String url}) async {
  //   try{
  //     Uri uri = Uri.parse(url);
  //     _preRequestLog(url);
  //     Response response = await get(uri);
  //     _postRequestLog(url, response.statusCode,
  //         headers: response.headers,
  //         responseBody: response.body);
  //
  //     if (response.statusCode == 200) {
  //       final decodedJson = jsonDecode(response.body);
  //       return NetworkResponse(
  //         isSuccess: true,
  //         statusCode: response.statusCode,
  //         data: decodedJson,
  //       );
  //     } else {
  //       final decodedJson = jsonDecode(response.body);
  //       String errorMessage = decodedJson['data']?? 'Something went wrong';
  //       return NetworkResponse(
  //           isSuccess: false, statusCode: response.statusCode, errorMessage: errorMessage);
  //     }
  //   } catch (e) {
  //     _postRequestLog(url,-1 , errorMassage: e.toString());
  //     return NetworkResponse(
  //         isSuccess: false, statusCode: -1, errorMessage: e.toString());
  //   }
  // }

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _preRequestLog(url);
      Response response = await get(uri);
      _postRequestLog(url, response.statusCode,
          headers: response.headers,
          responseBody: response.body);

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ?? false) {
          final decodedJson = jsonDecode(response.body);
          return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            data: decodedJson,
          );
        } else {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'Invalid response format (expected JSON)',
          );
        }
      } else {
        // Handle error JSON safely or fallback
        try {
          final decodedJson = jsonDecode(response.body);
          String errorMessage = decodedJson['data'] ?? 'Something went wrong';
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: errorMessage,
          );
        } catch (e) {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'Unexpected error format',
          );
        }
      }
    } catch (e) {
      _postRequestLog(url, -1, errorMassage: e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }


  static Future<NetworkResponse> postRequest({required String url,Map<String,dynamic>? body}) async {
    try{
      Uri uri = Uri.parse(url);
      _preRequestLog(url,body: body);

      Response response = await post(uri,
        headers: {
          'Content-Type': 'Application/json',
        }, body: jsonEncode(body),
      );
      _postRequestLog(url, response.statusCode,
          headers: response.headers,
          responseBody: response.body);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        String errorMessage = decodedJson['data']?? 'Something went wrong';
        return NetworkResponse(
            isSuccess: false, statusCode: response.statusCode, errorMessage: errorMessage);
      }
    } catch (e) {
      _postRequestLog(url,-1 , errorMassage: e.toString());
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static void _preRequestLog(String url, {Map<String, dynamic>? body}){
    _logger.i('URL => $url \n'
          'Body : $body');
  }
  static void _postRequestLog(String url, int statusCode,
      {Map<String, dynamic>? headers, dynamic responseBody, dynamic errorMassage}){
    if(errorMassage != null){
      _logger.e(''
          'URL: $url\n'
          'Status code: $statusCode\n'
          'Error Massage :$errorMassage');
    }else{
      _logger.i(''
          'URL: $url\n'
          'Status code: $statusCode\n'
          'Headers: $headers\n'
          'Response :$responseBody');
    }
  }
}
