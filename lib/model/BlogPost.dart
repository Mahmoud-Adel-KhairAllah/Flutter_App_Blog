// To parse this JSON data, do
//
//     final blogModel = blogModelFromJson(jsonString);

import 'dart:convert';

BlogModel blogModelFromJson(String str) => BlogModel.fromJson(json.decode(str));

String blogModelToJson(BlogModel data) => json.encode(data.toJson());

class BlogModel {
    BlogModel({
        this.userName,
        this.title,
        this.body,
        this.coverImage,
        this.like,
        this.share,
        this.comment,
        this.id,
        this.createdAt
    });

    final String? userName;
    final String? title;
    final String? body;
    final String? coverImage;
    final int? like;
    final int? share;
    final int? comment;
    final String? id;
    final String? createdAt;
    factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        userName: json["userName"],
        title: json["title"],
        body: json["body"],
        coverImage: json["coverImage"],
        like: json["like"],
        share: json["share"],
        comment: json["comment"],
        id: json["_id"],
        createdAt: json["createdAt"]==null?null:json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "title": title,
        "body": body,
        "coverImage": coverImage,
        "like": like,
        "share": share,
        "comment": comment,
        "_id": id,
        "createdAt": createdAt,
    };
}
