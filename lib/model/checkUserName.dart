// To parse this JSON data, do
//
//     final checkStatus = CheckStatusFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CheckStatus checkStatusFromJson(String str) => CheckStatus.fromJson(json.decode(str));

String checkStatusToJson(CheckStatus data) => json.encode(data.toJson());

class CheckStatus {
    CheckStatus({
        required this.status,
    });

    bool? status;

    factory CheckStatus.fromJson(Map<String, dynamic> json) => CheckStatus(
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "Status": status,
    };
}
