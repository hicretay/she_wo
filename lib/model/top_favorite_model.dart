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
    int id;
    String companyName;
    String companyLogo;

    Result({
        required this.id,
        required this.companyName,
        required this.companyLogo,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        companyName: json["companyName"],
        companyLogo: json["companyLogo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "companyName": companyName,
        "companyLogo": companyLogo,
    };
}
