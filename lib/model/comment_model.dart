// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
    bool success;
    List<Result> result;

    CommentModel({
        required this.success,
        required this.result,
    });

    factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        success: json["success"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Result {
    int userId;
    String userName;
    int companyId;
    DateTime registrationDate;
    String comment;
    double userPoint;

    Result({
        required this.userId,
        required this.userName,
        required this.companyId,
        required this.registrationDate,
        required this.comment,
        required this.userPoint,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        userId: json["userId"],
        userName: json["userName"],
        companyId: json["companyId"],
        registrationDate: DateTime.parse(json["registrationDate"]),
        comment: json["comment"],
        userPoint: json["userPoint"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "companyId": companyId,
        "registrationDate": registrationDate.toIso8601String(),
        "comment": comment,
        "userPoint": userPoint,
    };
}
