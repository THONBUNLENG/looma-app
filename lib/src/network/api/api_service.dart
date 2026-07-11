import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../manager/preferences_manager.dart';
import 'api_end_point.dart';

mixin EcommerceAPIService {
  static Future<Response> request(
      String path,
      DioMethods method, {
        Map<String, dynamic>? queryParams,
        dynamic data,
        bool isProtected = true,
      }) async {

    final List<ConnectivityResult> network = await Connectivity().checkConnectivity();
    if (network.contains(ConnectivityResult.none)) {
      throw 'No internet connection. Please check your network.';
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String? token = SharedPrefUtil.getString(PrefKey.token.toString());


    final dio = Dio(
      BaseOptions(
        baseUrl: EcommerceAPIEndPoint.instance.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: _generateHeaders(
          token: token,
          version: packageInfo.version,
          platform: Platform.isAndroid ? 'android' : 'ios',
        ),
      ),
    );

    dio.interceptors.add(LogInterceptor(
      requestBody: kDebugMode,
      responseBody: kDebugMode,
    ));

    try {
      Response response;
      switch (method) {
        case DioMethods.get:
          response = await dio.get(path, queryParameters: queryParams);
          break;
        case DioMethods.post:
          response = await dio.post(path, data: data);
          break;
        case DioMethods.put:
          response = await dio.put(path, data: data);
          break;
        case DioMethods.delete:
          response = await dio.delete(path, data: data);
          break;
      }

      return response;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Something went wrong';
      throw errorMessage;
    }
  }

  static Map<String, dynamic> _generateHeaders({
    String? token,
    required String version,
    required String platform,
  }) {
    return {
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      'Accept': 'application/json',
      'X-App-Version': version,
      'X-Platform': platform,
      'X-Store-Region': 'KH',
      'X-Currency': 'USD',
    };
  }
}

enum DioMethods { get, post, put, delete }