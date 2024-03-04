import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_oauth2/services/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class ApiInterceptor implements InterceptorContract {
  final storage = const FlutterSecureStorage();
  final AuthService authService = AuthService();

  Future<String> get tokenOrEmpty async {
    var token = await storage.read(key: "token");
    if (token == null) return "";
    return token;
  }

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String token = await tokenOrEmpty;
    try {
      data.headers["Authorization"] = "Bearer $token";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    var refreshToken = await storage.read(key: "refresh_token");
    if (data.statusCode == 401 && refreshToken != null) {
      var res = await authService.refreshToken(refreshToken);
      var data = jsonDecode(res!.body);
      await storage.write(key: "token", value: data['access_token']);
      await storage.write(key: "refresh_token", value: data['refresh_token']);
    }
    return data;
  }
}