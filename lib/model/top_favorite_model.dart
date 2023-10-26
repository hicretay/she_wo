// To parse this JSON data, do
//
//     final topFavoritesModel = topFavoritesModelFromJson(jsonString);

import 'dart:convert';

TopFavoritesModel topFavoritesModelFromJson(String str) => TopFavoritesModel.fromJson(json.decode(str));

String topFavoritesModelToJson(TopFavoritesModel data) => json.encode(data.toJson());

class TopFavoritesModel {
  bool success;
  List<Result> result;

  TopFavoritesModel({
    required this.success,
    required this.result,
  });

  factory TopFavoritesModel.fromJson(Map<String, dynamic> json) => TopFavoritesModel(
        success: json["success"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  dynamic id;
  String companyName;
  String companyLogo;
  int? commentsAvg;
  String? companyAddress;
  int? viewsNumber;

  Result({
    required this.id,
    required this.companyName,
    required this.companyLogo,
    this.commentsAvg,
    this.companyAddress,
    this.viewsNumber,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        companyName: json["companyName"],
        companyLogo: json["companyLogo"],
        commentsAvg: json["commentsAvg"],
        companyAddress: json["companyAddress"],
        viewsNumber: json["viewsNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "companyName": companyName,
        "companyLogo": companyLogo,
        "commentsAvg": commentsAvg,
        "companyAddress": companyAddress,
        "viewsNumber": viewsNumber,
      };
}
