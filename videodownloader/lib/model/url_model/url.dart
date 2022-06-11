// To parse this JSON data, do
//
//     final urlModel = urlModelFromJson(jsonString);

import 'dart:convert';

UrlModel urlModelFromJson(String str) => UrlModel.fromJson(json.decode(str));

String urlModelToJson(UrlModel data) => json.encode(data.toJson());

class UrlModel {
  UrlModel({
    this.status,
    this.output,
    this.message,
  });

  bool? status;
  String? output;
  dynamic message;

  factory UrlModel.fromJson(Map<String, dynamic> json) => UrlModel(
    status: json["status"] != null ?json["status"] : false ,
    output: json["output"] != null ? json["output"] : "",
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "output": output,
    "message": message,
  };
}
