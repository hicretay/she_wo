// To parse this JSON data, do
//
//     final homeCategoriesModel = homeCategoriesModelFromJson(jsonString);

import 'dart:convert';

HomeCategoriesModel homeCategoriesModelFromJson(String str) => HomeCategoriesModel.fromJson(json.decode(str));

String homeCategoriesModelToJson(HomeCategoriesModel data) => json.encode(data.toJson());

class HomeCategoriesModel {
    bool success;
    List<Result> result;

    HomeCategoriesModel({
        required this.success,
        required this.result,
    });

    factory HomeCategoriesModel.fromJson(Map<String, dynamic> json) => HomeCategoriesModel(
        success: json["success"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Result {
    int categoryId;
    String categoryName;
    String categoryLogo;

    Result({
        required this.categoryId,
        required this.categoryName,
        required this.categoryLogo,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        categoryLogo: json["categoryLogo"],
    );

    Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "categoryLogo": categoryLogo,
    };
}
