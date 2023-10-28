// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:she_wo/JsnClass/appointment_add_jsn.dart';
import 'package:she_wo/JsnClass/appointment_delete_jsn.dart';
import 'package:she_wo/JsnClass/appointment_list.dart';
import 'package:she_wo/JsnClass/company_appointment_list_jsn.dart';
import 'package:she_wo/JsnClass/company_list_jsn.dart';
import 'package:she_wo/JsnClass/company_operation_jsn.dart';
import 'package:she_wo/JsnClass/company_operation_time.dart';
import 'package:she_wo/JsnClass/login_jsn.dart';
import 'package:she_wo/model/comment_model.dart';
import 'package:she_wo/model/company_detail_model.dart';
import 'package:she_wo/model/top_favorite_model.dart';
import 'package:she_wo/screens/login_page.dart';
import 'package:she_wo/settings/consts.dart';

import '../JsnClass/general_response_model.dart';

String baseUrl = "https://service.shewoo.com/api/";

Map<String, String> header = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Credentials": true.toString(),
  "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "POST, OPTIONS"
};

//---------------------------------------------------Login Fonksiyonu-------------------------------------------------------------
Future<LoginJsn?> loginJsnFunc(String userName, String password) async {
  final response = await http.post(
    Uri.parse("${baseUrl}LoginJsn"),
    body: '{"userName":"$userName","password":"$password"}',
    headers: header,
  );

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return loginJsnFromJson(responseString);
  } else {
    return null;
  }
}
//---------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------Firmaların Listesi Fonksiyonu-----------------------------------------
Future<CompanyListJsn?> companyListJsnFunc() async {
  final response = await http.post(Uri.parse("${baseUrl}CompanyList"), headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return companyListJsnFromJson(responseString);
  } else {
    return null;
  }
}

//-------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------Categori Firmalarının Listesi Fonksiyonu-----------------------------------------
Future<TopFavoritesModel?> categoryCompanyListJsnFunc(int categoryId) async {
  final response = await http.post(Uri.parse("${baseUrl}CategoryOperation/CategoryCompanyList"), body: '{"categoryId":$categoryId}', headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return topFavoritesModelFromJson(responseString);
  } else {
    return null;
  }
}

//----------------------------------------------------Kampanyalı İşlemler Fonksiyonu--------------------------------------------------
Future<CompanyOperationJsn?> companyOperationJsnFunc(int id) async {
  final response = await http.post(Uri.parse("${baseUrl}CompanyOperation/List"), body: '{"companyId":$id}', headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return companyOperationJsnFromJson(responseString);
  } else {
    return null;
  }
}
//-------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------İşlem Saatleri Fonksiyonu--------------------------------------------------
Future<CompanyOperationTimeJsn?> companyOperationTimeJsnFunc(List id) async {
  final response = await http.post(Uri.parse("${baseUrl}CompanyOperation/Time"), body: '{"operationId":$id}', headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return companyOperationTimeJsnFromJson(responseString);
  } else {
    return null;
  }
}
//----------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------Kullanıcının Randevuları Listesi Fonksiyonu-------------------------------------------------
Future<AppointmentListJsn?> appointmentListJsnFunc(int userId, String? appointmentDate) async {
  final response =
      await http.post(Uri.parse("${baseUrl}Appointment/List"), body: '{"userId":$userId,"appointmentDate":"$appointmentDate"}', headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return appointmentListJsnFromJson(responseString);
  } else {
    return null;
  }
}

Future<AppointmentListJsn?> allAppointmentListJsnFunc(int userId) async {
  final response = await http.post(Uri.parse("${baseUrl}Appointment/List"), body: '{"userId":$userId}', headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return appointmentListJsnFromJson(responseString);
  } else {
    return null;
  }
}

//-----------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------Firma Sahibinin Randevuları Listesi Fonksiyonu-------------------------------------------------
Future<CompanyAppointmentListJsn?> appointmentCompanyListJsnFunc(int userId, String? appointmentDate) async {
  final response = await http.post(Uri.parse("${baseUrl}Appointment/CompanyList"),
      body: '{"userId":$userId,"appointmentDate":"$appointmentDate"}', headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return companyAppointmentListJsnFromJson(responseString);
  } else {
    return null;
  }
}

//-----------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------- Randevu Ekleme Fonksiyonu-----------------------------------------------------
Future<AppointmentAddJsn?> appointmentAddJsnFunc(
    int userId, int companyId, int campaingId, String appointmentDate, int appointmentTimeId, int operation, String specialNote) async {
  var bodys = {};
  bodys["userId"] = userId;
  bodys["companyId"] = companyId;
  bodys["campaingId"] = campaingId;
  bodys["appointmentDate"] = appointmentDate;
  bodys["appointmentTimeId"] = appointmentTimeId;
  bodys["operation"] = operation;
  bodys["specialNote"] = specialNote;

  String body = json.encode(bodys);

  final response = await http.post(Uri.parse("${baseUrl}Appointment/Add"), body: body, headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return appointmentAddJsnFromJson(responseString);
  } else {
    print(response.statusCode);
    return null;
  }
}
//-------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------- Randevu Silme Fonksiyonu-----------------------------------------------------
Future<AppointmentDeleteJsn?> appointmentDeleteJsnFunc(int id) async {
  var bodys = {};
  bodys["id"] = id;

  String body = json.encode(bodys);

  final response = await http.post(Uri.parse("${baseUrl}Appointment/Delete"), body: body, headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return appointmentDeleteJsnFromJson(responseString);
  } else {
    print(response.statusCode);
    return null;
  }
}
//------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------- Randevu Onaylama Fonksiyonu-----------------------------------------------------
Future<AppointmentDeleteJsn?> appointmentApproveJsnFunc(int id) async {
  var bodys = {};
  bodys["id"] = id;

  String body = json.encode(bodys);

  final response = await http.post(Uri.parse("${baseUrl}Appointment/CompanyConfirm"), body: body, headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return appointmentDeleteJsnFromJson(responseString);
  } else {
    print(response.statusCode);
    return null;
  }
}
//------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------Kullanıcı Kayıt Fonksiyonu-----------------------------------------------------
Future<GeneralResponseModel?> userAddJsnFunc(
    String nameSurname, String email, String telephone, String password, String facebookToken, String googleToken) async {
  var bodys = {};
  bodys["nameSurname"] = nameSurname;
  bodys["email"] = email;
  bodys["telephone"] = telephone;
  bodys["password"] = password;
  bodys["facebookToken"] = facebookToken;
  bodys["googleToken"] = googleToken;

  String body = json.encode(bodys);

  final response = await http.post(Uri.parse("${baseUrl}AddUser"), body: body, headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return generalResponseModelFromJson(responseString);
  } else {
    print(response.statusCode);
    return null;
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------Şifremi Unuttum Fonksiyonu----------------------------------------------------
Future<GeneralResponseModel?> forgetPasswordJsnFunc(String eMail) async {
  final response = await http.post(Uri.parse("${baseUrl}ForgetPassword"), body: '{"userName":"$eMail"}', headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return generalResponseModelFromJson(responseString);
  } else {
    return null;
  }
}

//-------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------Toast Mesaj Gösterme Fonksiyonu--------------------------------------------------------
showToast(BuildContext context, String content) async {
  return await Fluttertoast.showToast(
    msg: content,
    backgroundColor: tertiaryColor,
    timeInSecForIosWeb: 3,
    textColor: primaryColor,
    gravity: ToastGravity.CENTER,
  );
}

//----------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------Kullanıcıya Dönüt - Uyarı Dialog Fonksiyonu------------------------------------------------
showAlert(BuildContext context, String content) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(content, style: const TextStyle(fontFamily: contentFont)),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              MaterialButton(
                  color: tertiaryColor,
                  child: const Text("Kapat", style: TextStyle(fontFamily: leadingFont, color: white)),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  }),
            ]),
          ],
        );
      });
}

//---------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------ÜYELİK UYARISI DİYALOGU------------------------------------------------------------
showNotMemberAlert(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Devam etmek için lütfen üye olunuz !", style: TextStyle(fontFamily: contentFont)),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              MaterialButton(
                  color: primaryColor,
                  child: const Text("Kayıt Ol", style: TextStyle(fontFamily: leadingFont, color: white)),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                  }),
              MaterialButton(
                  color: primaryColor,
                  child: const Text("Kapat", style: TextStyle(fontFamily: leadingFont, color: white)),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  }),
            ]),
          ],
        );
      });
}
//---------------------------------------------------------------------------------------------------------------------------------

Future<CompanyDetailModel?> companyDetailFunc(int companyId) async {
  final response = await http.post(Uri.parse("${baseUrl}CompanyList/Detail"), body: '{"companyId":$companyId}', headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return companyDetailModelFromJson(responseString);
  } else {
    return null;
  }
}

Future<TopFavoritesModel?> searchListFunc(String search, String location) async {
  var bodys = {};
  bodys["q"] = search;
  bodys["location"] = location;

  String body = json.encode(bodys);

  final response = await http.post(Uri.parse("${baseUrl}Search"), body: body, headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return topFavoritesModelFromJson(responseString);
  } else {
    return null;
  }
}

//------------------Yorum Ekleme----------------------
Future commentAddFunc(int userId, int companyId, String comment, double userPoint) async {
  var bodys = {};
  bodys["userId"] = userId;
  bodys["companyId"] = companyId;
  bodys["comment"] = comment;
  bodys["userPoint"] = userPoint;

  String body = json.encode(bodys);

  final response = await http.post(Uri.parse("${baseUrl}CompanyComment/Add"), body: body, headers: header);

  if (response.statusCode == 200) {
    return commentResultModelFromJson(response.body);
  } else {
    print(response.statusCode);
    return null;
  }
}

//---------------Yorum Listeleme----------------------

Future<CommentModel?> commentListJsnFunc(int companyId) async {
  final response = await http.post(Uri.parse("${baseUrl}CompanyComment/List"), body: '{"companyId":$companyId}', headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return commentModelFromJson(responseString);
  } else {
    return null;
  }
}

//-------------------Yorum Silme----------------------------

Future commentDeleteJsnFunc(int userId, int companyId) async {
  var bodys = {};
  bodys["userId"] = userId;
  bodys["companyId"] = companyId;

  String body = json.encode(bodys);

  final response = await http.post(Uri.parse("${baseUrl}CompanyComment/Delete"), body: body, headers: header);

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print(response.statusCode);
    return null;
  }
}


//----------------------------------View Count------------------------------------
Future<GeneralResponseModel?> viewCountFunc(int userId, int? companyId) async {
  final response =
      await http.post(Uri.parse("${baseUrl}CompanyList/Views"), body: '{"userId":$userId,"companyId":"$companyId"}', headers: header);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return generalResponseModelFromJson(responseString);
  } else {
    return null;
  }
}

//-----------------------Resmi base64'e dönüştürme(encode)----------------------
String imageToBase64(File imagePath) {
  var imageBytes = imagePath.readAsBytesSync();
  var encodedImage = base64.encode(imageBytes);
  //encodedImage: base64' e dönüşmüş resim
  return encodedImage;
}
//------------------------------------------------------------------------------

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
