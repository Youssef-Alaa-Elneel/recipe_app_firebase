// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// class ApiClient {
//   String baseUrl = 'https://dummyjson.com';

//   late Dio _dio;

//   ApiClient() {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: baseUrl,

//         headers: {'Content-Type': 'application/json'},
//       ),
//     );

//     if (kDebugMode) {
//       _dio.interceptors.add(
//         PrettyDioLogger(
//           requestHeader: true,
//           requestBody: true,
//           responseBody: true,
//           responseHeader: true,
//           error: true,
//           compact: true,
//           maxWidth: 90,
//           enabled: kDebugMode,
//         ),
//       );
//     }

//     // Add authorization interceptor
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           print(options.data);
//           // Add authorization token to all requests
//           return handler.next(options);
//         },
//         onError: (DioException error, handler) async {
//           if (error.response?.statusCode == 401) {
//             // Check if the request is login

//             return handler.next(error);
//           }
//           return handler.next(error);
//         },
//       ),
//     );
//   }

//   Future<Response> getData(
//     String url, {
//     Map<String, dynamic>? query,
//     Map<String, String>? headers,
//   }) async {
//     try {
//       final response = await _dio.get(
//         url,
//         queryParameters: query,
//         options: Options(headers: headers),
//       );
//       return response;
//     } catch (e) {
//       return Response(statusCode: 1, requestOptions: RequestOptions());
//     }
//   }

//   Future<Response> postUser(
//     String uri,
//     dynamic body, {
//     Map<String, String>? headers,
//   }) async {
//     try {
//       final response = await _dio.post(
//         uri,
//         data: body,
//         options: Options(headers: headers),
//       );
//       return response;
//     } catch (e) {
//       return Response(statusCode: 1, requestOptions: RequestOptions());
//     }
//   }

//   Future<Response> putData(
//     String uri,
//     dynamic body, {
//     Map<String, String>? headers,
//   }) async {
//     try {
//       final response = await _dio.put(
//         uri,
//         data: body,
//         options: Options(headers: headers),
//       );
//       return response;
//     } catch (e) {
//       return Response(statusCode: 1, requestOptions: RequestOptions());
//     }
//   }

//   Future<Response> patchData(
//     String uri,
//     dynamic body, {
//     Map<String, String>? headers,
//   }) async {
//     try {
//       final response = await _dio.patch(
//         uri,
//         data: body,
//         options: Options(headers: headers),
//       );
//       return response;
//     } catch (e) {
//       return Response(statusCode: 1, requestOptions: RequestOptions());
//     }
//   }

//   Future<Response> deleteData(
//     String uri, {
//     Map<String, String>? headers,
//   }) async {
//     try {
//       final response = await _dio.delete(
//         uri,
//         options: Options(headers: headers),
//       );
//       return response;
//     } catch (e) {
//       return Response(statusCode: 1, requestOptions: RequestOptions());
//     }
//   }
// }
