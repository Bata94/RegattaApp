import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:regatta_app/models/user.dart';
import 'package:regatta_app/provider/auth.dart';
import 'package:regatta_app/services/navigation.dart';

class ApiUrl {
  static const localUrl = "http://192.168.80.20:8080/api";
  // static const localUrl = "http://localhost:8080/api";
  // static const localUrl = "http://10.0.2.2:8080/api";

  static const baseUrl = localUrl;

  static const login = "$baseUrl/auth/login";
  static const logout = "$baseUrl/auth/logout";
  static const userValidate = "$baseUrl/auth/valid";
  static const me = "$baseUrl/auth/me";

  static const v1Url = "$baseUrl/v1";

  static const athlet = "$v1Url/athlet";
  static const athletenWaage = "$v1Url/athlet/waage";
  static const athletenStartberechtigung = "$v1Url/athlet/startberechtigung";

  static const pause = "$v1Url/pause";

  static const bueroAbmeldung = "$v1Url/buero/abmeldung";

  static const rennen = "$v1Url/rennen";

  static const meldung = "$v1Url/meldung";
  static const ummeldung = "$v1Url/meldung/ummeldung";
  static const nachmeldung = "$v1Url/meldung/nachmeldung";
  static const meldungForVerein = "$v1Url/meldung/verein";

  static const vereine = "$v1Url/verein";
  static const vereinAthlet = "$v1Url/verein/<param>/athlet";
  static const vereinWaage = "$v1Url/verein/<param>/waage";
  static const vereinStartberechtigung = "$v1Url/verein/<param>/startberechtigung";

  static const drvMeldUpload = "$v1Url/leitung/drv_meldung_upload";
  static const setzungsLosung = "$v1Url/leitung/setzungslosung";
  static const setzungsLosungReset = "$v1Url/leitung/setzungslosung/reset";
  static const setZeitplan = "$v1Url/leitung/setzeitplan";
  static const setStartnummern = "$v1Url/leitung/setstartnummern";
  static const postSetzungLs = "$v1Url/meldung/updateSetzungBatch";
  static const listMeldeergebnis = "$v1Url/leitung/meldeergebnis/list";
  static const createMeldeergebnis = "$v1Url/leitung/meldeergebnis";
  static const downloadMeldeergebnis = "$v1Url/leitung/meldeergebnis/<param>";
}

class ApiResponse {
  bool status;
  int statusCode;
  int code;
  String error;
  String msg;
  dynamic data;

  ApiResponse({
    required this.status,
    required this.statusCode,
    required this.code,
    this.error = "",
    this.msg = "",
    this.data = const {},
  });
}

class ApiRequester{
  String baseUrl;
  Map<String, dynamic>? headers;
  bool securedEndpoint;
  int timeoutSec;

  ApiRequester({
    required this.baseUrl,
    this.headers,
    this.securedEndpoint = true,
    this.timeoutSec = 30,
  });

  Uri parseUri(String baseUrl, {String? param, Map<String, dynamic>? queryParams}) {
    String uriStr = "";
    if (param == null) {
      uriStr = baseUrl;
    } else if (baseUrl.contains("<param>")) {
      uriStr = baseUrl.replaceFirst("<param>", param);
    } else {
      uriStr = "$baseUrl/$param";
    }

    if (queryParams != null) {
      uriStr += "?";
      queryParams.forEach((key, value) {uriStr += "$key=$value&";});
      uriStr = uriStr.substring(0, uriStr.length - 1);
    }

    return Uri.parse(uriStr);
  }

  Future<Map<String, String>> setHeaders() async {
    final context = NavigationService.navigatorKey.currentContext!;
    Map<String, String> baseHeaders = {
      'Content-Type': 'application/json',
    };

    if (securedEndpoint) {
      User? user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user == null) {
        throw Exception("No user found!");
      }
      baseHeaders['Authorization'] = 'Bearer ${user.jwt.token}';
    }

    if (headers != null) {
      headers!.forEach((key, value) {baseHeaders[key] = value.toString();});
    }

    return baseHeaders;
  }

  ApiResponse parseApiResponse(http.Response res) {
    dynamic body;
    try {
      body = json.decode(utf8.decode(res.bodyBytes));
    } catch (e) {
      String msg = utf8.decode(res.bodyBytes);
      msg = msg.substring(1, msg.length - 1);
      body = {"msg": msg};
    }

    try {
      if (res.statusCode == 200) {
        return ApiResponse(status: true, statusCode: res.statusCode, code: res.statusCode, data: body);
      } else {
        return ApiResponse(status: false, statusCode: res.statusCode, code: body['code'], error: body['error'], msg: body['message'], data: body);
      }
    } catch (e) {
      return ApiResponse(status: false, statusCode: 999, code: 999, error: "Failed to parse Response!", msg: "$e\n${res.statusCode} - ${res.body}",);
    }
  }
  
  ApiResponse connectionError(Object e) {
    return ApiResponse(status: false, statusCode: 999, code: 999, error: "Failed to connect to server!", msg: e.toString(),);
  }

  Future<ApiResponse> get({String? param, Map<String, dynamic>? queryParams}) async {
    http.Response res;

    Uri uri = parseUri(baseUrl, param: param, queryParams: queryParams);
    Map<String, String> reqHeaders = await setHeaders();

    try {
      res = await http.get(
        uri,
        headers: reqHeaders,
      ).timeout(Duration(seconds: timeoutSec));
    } catch (e) {
      return connectionError(e);
    }

    return parseApiResponse(res);
  }

  Future<ApiResponse> delete(String param) async {
    http.Response res;

    Uri uri = parseUri(baseUrl, param: param);
    Map<String, String> reqHeaders = await setHeaders();

    try {
      res = await http.delete(
        uri,
        headers: reqHeaders,
      ).timeout(Duration(seconds: timeoutSec));
    } catch (e) {
      return connectionError(e);
    }

    return parseApiResponse(res);
  }
  
  Future<ApiResponse> post({Map<String, dynamic> body = const {}}) async {
    Uri uri = Uri.parse(baseUrl);
    http.Response res;

    Map<String, String> reqHeaders = await setHeaders();
    var bodyEnc = jsonEncode(body);

    try {
      res = await http.post(
        uri,
        body: bodyEnc,
        headers: reqHeaders,
      ).timeout(Duration(seconds: timeoutSec));
    } catch (e) {
      return connectionError(e);
    }

    return parseApiResponse(res);
  }

  Future<Uint8List?> downloadFile(String param) async {
    Uri uri = parseUri(baseUrl, param: param); 
    Map<String, String> reqHeaders = await setHeaders();
    http.Response res;

    try {
      res = await http.get(
        uri,
        headers: reqHeaders,
      ).timeout(Duration(seconds: timeoutSec));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    
    if (res.statusCode >= 400) {
      return null;
    }
 
    return res.bodyBytes;
  }
   
  Future<Uint8List?> downloadFilePost() async {
    Uri uri = parseUri(baseUrl); 
    Map<String, String> reqHeaders = await setHeaders();
    http.Response res;

    try {
      res = await http.post(
        uri,
        headers: reqHeaders,
      ).timeout(Duration(seconds: timeoutSec));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    
    if (res.statusCode >= 400) {
      return null;
    }
 
    return res.bodyBytes;
  }

  Future<ApiResponse> uploadFile(File file) async {
    Uri uri = Uri.parse(baseUrl);
    http.Response res;
    http.StreamedResponse streamRes;

    Map<String, String> reqHeaders = await setHeaders();
    reqHeaders['Content-Type'] = 'multipart/form-data';
    http.MultipartRequest req = http.MultipartRequest("POST", uri)
      ..files.add(await http.MultipartFile.fromPath("file", file.path));

    try {
      streamRes = await req.send(); 
      res = await http.Response.fromStream(streamRes);
    } catch (e) {
      return connectionError(e);
    }

    return parseApiResponse(res);
  }

  Future<ApiResponse> put({Map<String, dynamic> body = const {}}) async {
    Uri uri = Uri.parse(baseUrl);
    http.Response res;

    Map<String, String> reqHeaders = await setHeaders();
    var bodyEnc = jsonEncode(body);

    try {
      res = await http.put(
        uri,
        body: bodyEnc,
        headers: reqHeaders,
      ).timeout(Duration(seconds: timeoutSec));
    } catch (e) {
      return connectionError(e);
    }

    return parseApiResponse(res);
  }
}
