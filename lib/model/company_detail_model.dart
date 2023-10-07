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
    int campaignCount;
    int favCount;
    String eMail;
    String web;
    dynamic address;
    List<CampaignList> campaignList;

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
        required this.campaignList,
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
        campaignList: List<CampaignList>.from(json["campaignList"].map((x) => CampaignList.fromJson(x))),
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
        "campaignList": List<dynamic>.from(campaignList.map((x) => x.toJson())),
    };
}

class CampaignList {
    int campaingId;
    String campaingName;
    String campaingLogo;

    CampaignList({
        required this.campaingId,
        required this.campaingName,
        required this.campaingLogo,
    });

    factory CampaignList.fromJson(Map<String, dynamic> json) => CampaignList(
        campaingId: json["campaingId"],
        campaingName: json["campaingName"],
        campaingLogo: json["campaingLogo"],
    );

    Map<String, dynamic> toJson() => {
        "campaingId": campaingId,
        "campaingName": campaingName,
        "campaingLogo": campaingLogo,
    };
}
