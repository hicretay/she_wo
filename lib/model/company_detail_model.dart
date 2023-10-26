// To parse this JSON data, do
//
//     final companyDetailModel = companyDetailModelFromJson(jsonString);

import 'dart:convert';

CompanyDetailModel companyDetailModelFromJson(String str) => CompanyDetailModel.fromJson(json.decode(str));

String companyDetailModelToJson(CompanyDetailModel data) => json.encode(data.toJson());

class CompanyDetailModel {
    bool success;
    Result result;

    CompanyDetailModel({
        required this.success,
        required this.result,
    });

    factory CompanyDetailModel.fromJson(Map<String, dynamic> json) => CompanyDetailModel(
        success: json["success"],
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "result": result.toJson(),
    };
}

class Result {
    int id;
    String companyName;
    String companyLogo;
    String companyPhone;
    String companyPhone2;
    String googleAdressLink;
    int likeCount;
    dynamic campaignCount;
    int favCount;
    String eMail;
    String web;
    dynamic address;
    dynamic commentsAvg;
    int viewsNumber;
    List<CommentList> commentList;

    Result({
        required this.id,
        required this.companyName,
        required this.companyLogo,
        required this.companyPhone,
        required this.companyPhone2,
        required this.googleAdressLink,
        required this.likeCount,
        required this.campaignCount,
        required this.favCount,
        required this.eMail,
        required this.web,
        required this.address,
        required this.commentsAvg,
        required this.viewsNumber,
        required this.commentList,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        companyName: json["companyName"],
        companyLogo: json["companyLogo"],
        companyPhone: json["companyPhone"],
        companyPhone2: json["companyPhone2"],
        googleAdressLink: json["googleAdressLink"],
        likeCount: json["likeCount"],
        campaignCount: json["campaignCount"],
        favCount: json["favCount"],
        eMail: json["eMail"],
        web: json["web"],
        address: json["address"],
        commentsAvg: json["commentsAvg"],
        viewsNumber: json["viewsNumber"],
        commentList: List<CommentList>.from(json["commentList"].map((x) => CommentList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "companyName": companyName,
        "companyLogo": companyLogo,
        "companyPhone": companyPhone,
        "companyPhone2": companyPhone2,
        "googleAdressLink": googleAdressLink,
        "likeCount": likeCount,
        "campaignCount": campaignCount,
        "favCount": favCount,
        "eMail": eMail,
        "web": web,
        "address": address,
        "commentsAvg": commentsAvg,
        "viewsNumber": viewsNumber,
        "commentList": List<dynamic>.from(commentList.map((x) => x.toJson())),
    };
}

class CommentList {
    int id;
    int userId;
    int companyId;
    DateTime registrationDate;
    String comment;
    String userName;
    double userPoint;

    CommentList({
        required this.id,
        required this.userId,
        required this.companyId,
        required this.registrationDate,
        required this.comment,
        required this.userName,
        required this.userPoint,
    });

    factory CommentList.fromJson(Map<String, dynamic> json) => CommentList(
        id: json["id"],
        userId: json["userId"],
        companyId: json["companyId"],
        registrationDate: DateTime.parse(json["registrationDate"]),
        comment: json["comment"],
        userName: json["userName"],
        userPoint: json["userPoint"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "companyId": companyId,
        "registrationDate": registrationDate.toIso8601String(),
        "comment": comment,
        "userName": userName,
        "userPoint": userPoint,
    };
}
