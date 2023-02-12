// To parse this JSON data, do
//
//     final ProfileModel = ProfileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    ProfileModel({
      this.userName,
        this.name,
        this.profession,
        this.titleLine,
        this.dob,
        this.about,
        this.img,
    });
 String? name;
     String? userName;
     String? profession;
     String? titleLine;
     String? dob;
     String? about;
     String? img;

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        userName: json["userName"]!=null?json["userName"]:"",
        name: json["name"],
        profession: json["profession"],
        titleLine: json["titleLine"],
        dob: json["DOB"],
        about: json["about"],
        img: json["img"],
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "name": name,
        "profession": profession,
        "titleLine": titleLine,
        "DOB": dob,
        "about": about,
        "img": img,
    };
}
