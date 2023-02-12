import 'dart:convert';

import 'package:flutter_blog/model/BlogPost.dart';
import 'package:flutter_blog/model/ProfileModel.dart';

ResponseBlogModel responseBlogModelFromJson(String str) => ResponseBlogModel.fromJson(json.decode(str));

String responseBlogModelToJson(ResponseBlogModel data) => json.encode(data.toJson());

class ResponseBlogModel {
    ResponseBlogModel({
        this.data,
    });

    final BlogModel? data;
     

    factory ResponseBlogModel.fromJson(Map<String, dynamic> json) => ResponseBlogModel(
        data: json["data"] == null ? null : BlogModel.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}