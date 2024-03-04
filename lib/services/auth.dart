import 'dart:convert';

import 'package:flutter_oauth2/helpers/constant.dart';
import 'package:http/http.dart';

class AuthService {
  var loginUri = Uri.parse('${Constants.baseUrl}/oauth/token');
  var registerUri = Uri.parse('${Constants.baseUrl}/oauth/signup');

  Future<Response?> login(String username, String password) async {
    String client = 'express-client';
    String secret = 'express-secret';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';
    var res = await post(
        loginUri,
        headers: <String, String>{'authorization': basicAuth},
        body: {
          "username": username,
          "grant_type": "password",
          "password": password
        }
    );
    return res;
  }

  Future<Response?> refreshToken(String token) async {
    String client = 'express-client';
    String secret = 'express-secret';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';
    var res = await post(
        loginUri,
        headers: <String, String>{'authorization': basicAuth},
        body: {
          "refresh_token": token,
          "grant_type": "refresh_token"
        }
    );
    return res;
  }

  Future<Response?> register(String username, String password, String name) async {
    var res = await post(
        registerUri,
        body: {
          "username": username,
          "password": password,
          "name": name
        }
    );
    return res;
  }
}