// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    this.userName,
    this.password,
    this.email,
  });

  String? userName;
  String? password;

  String? email;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        userName: json["userName"],
        password: json["password"],
        email: json["Eemail"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "password": password,
        "email": email,
      };
}
