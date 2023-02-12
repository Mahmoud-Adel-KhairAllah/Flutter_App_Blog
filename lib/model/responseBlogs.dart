// To parse this JSON data, do
//
//     final responseBlogsModel = responseBlogsModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_blog/model/BlogPost.dart';

ResponseBlogsModel responseBlogsModelFromJson(String str) => ResponseBlogsModel.fromJson(json.decode(str));

String responseBlogsModelToJson(ResponseBlogsModel data) => json.encode(data.toJson());

class ResponseBlogsModel {
    ResponseBlogsModel({
        this.data,
    });

    final List<BlogModel>? data;

    factory ResponseBlogsModel.fromJson(Map<String, dynamic> json) => ResponseBlogsModel(
        data: json["data"] == null ? [] : List<BlogModel>.from(json["data"]!.map((x) => BlogModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}