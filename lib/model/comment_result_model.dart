import 'dart:convert';

CommentResultModel commentResultModelFromJson(String str) => CommentResultModel.fromJson(json.decode(str));

String commentResultModelToJson(CommentResultModel data) => json.encode(data.toJson());

class CommentResultModel {
  bool success;
  String result;

  CommentResultModel({
    required this.success,
    required this.result,
  });

  factory CommentResultModel.fromJson(Map<String, dynamic> json) => CommentResultModel(
        success: json["success"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": result,
      };
}