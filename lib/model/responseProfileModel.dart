import 'dart:convert';

import 'package:flutter_blog/model/ProfileModel.dart';

ResponseProfileModel responseProfileModelFromJson(String str) => ResponseProfileModel.fromJson(json.decode(str));

String responseProfileModelToJson(ResponseProfileModel data) => json.encode(data.toJson());

class ResponseProfileModel {
    ResponseProfileModel({
        this.data,
    });

    final ProfileModel? data;

    factory ResponseProfileModel.fromJson(Map<String, dynamic> json) => ResponseProfileModel(
        data: json["data"] == null ? null : ProfileModel.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}