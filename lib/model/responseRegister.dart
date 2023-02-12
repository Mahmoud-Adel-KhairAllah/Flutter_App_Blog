// To parse this JSON data, do
//
//     final responseRegisterModel = responseRegisterModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ResponseRegisterModel responseRegisterModelFromJson(String str) => ResponseRegisterModel.fromJson(json.decode(str));

String responseRegisterModelToJson(ResponseRegisterModel data) => json.encode(data.toJson());

class ResponseRegisterModel {
    ResponseRegisterModel({
        required this.result,
        required this.token,
        required this.msg,
    });

    bool? result;
    String? token;
    String? msg;

    factory ResponseRegisterModel.fromJson(Map<String, dynamic> json) => ResponseRegisterModel(
        result: json["result"],
        token: json["token"],
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "token": token,
        "msg": msg,
    };
}
