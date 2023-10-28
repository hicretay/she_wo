import 'dart:convert';

GeneralResponseModel generalResponseModelFromJson(String str) => GeneralResponseModel.fromJson(json.decode(str));

String generalResponseModelToJson(GeneralResponseModel data) => json.encode(data.toJson());

class GeneralResponseModel {
    GeneralResponseModel({
        this.success,
        this.result,
    });

    bool? success;
    String? result;

    factory GeneralResponseModel.fromJson(Map<String, dynamic> json) => GeneralResponseModel(
        success: json["success"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "result": result,
    };
}