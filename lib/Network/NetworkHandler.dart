import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class NetWorkHandler {
  var clint = http.Client();
  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<dynamic> get(String url) async {
    String? token = await secureStorage.read(key: 'token');
    log(token.toString() + "<===========================token");

    var response = await clint.get(buildUrl(url), headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    });
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');
    return response.body;
  }

  Future<dynamic> post(String url, var body) async {
    String? token = await secureStorage.read(key: 'token');
    log("$body<================map");
    var response = await clint.post(buildUrl(url), body: body, headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      log("${response.body}<=====================body");
      return response.body;
    }
    return response.body;
  }

  Future<dynamic> patchImage(String url, String filePath) async {
    log(filePath+"<==============filepath");
    String? token = await secureStorage.read(key: 'token');
    var request = http.MultipartRequest('PATCH', buildUrl(url));
    request.files.add(await http.MultipartFile.fromPath("img", filePath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response=request.send();
    
  log('${response.ignore}'+"<====================responseimage");

    return response;
  }

  NetworkImage getImage(String urlpath){
    String url=buildUrl(urlpath).toString();
    return NetworkImage(url);
  }

  static Uri buildUrl(String endpoint) {
    String host = "http://10.0.0.23:1000/";
    final apiPath = host + endpoint;
    return Uri.parse(apiPath);
  }
}
