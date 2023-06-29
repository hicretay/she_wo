// ignore_for_file: unnecessary_null_comparison

import 'package:she_wo/widgets/webViewWidget.dart';
import 'package:she_wo/screens/loginPage.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterPage extends StatefulWidget {
  static const route = "/registerPage";
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController txtNameSurname = TextEditingController();
  TextEditingController txtEMail = TextEditingController();
  TextEditingController txtTelephone = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtPasswordAgain = TextEditingController();

  bool checkedPrivacy = true;

  var maskFormatter = MaskTextInputFormatter(mask: '+90 (###) ### ## ##', filter: {"#": RegExp(r'[0-9]')}, initialText: "+90");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Stack(
            children: [
              SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      SizedBox(height: deviceWidth(context) * 0.2),
                      //--------------------------giriş ikonu----------------------------------
                      SizedBox(
                          width: deviceWidth(context),
                          height: deviceWidth(context) * 0.5,
                          child: Center(child: Image.asset("assets/images/shewo_logo.png"))),
                      //------------------------------------------------------------------
                      SingleChildScrollView(
                        reverse: true,
                        child: Padding(
                          padding: const EdgeInsets.only(left: minSpace, right: minSpace, bottom: minSpace),
                          child: Column(
                            children: [
                              //---------------------------Ad-Soyad textField'ı---------------------------------------
                              TextFieldWidget(
                                textEditingController: txtNameSurname,
                                keyboardType: TextInputType.name,
                                hintText: "Ad Soyad*", //ipucu metni
                                obscureText: false, // yazılanlar gizlenmesin
                              ),
                              //-----------------------------Eposta textField'ı----------------------------------------
                              TextFieldWidget(
                                textEditingController: txtEMail,
                                keyboardType: TextInputType.emailAddress,
                                hintText: "E-Posta*", //ipucu metni
                                obscureText: false, // yazılanlar gizlenmesin
                              ),
                              //-----------------------------Telefon textField'ı--------------------------------------
                              TextFieldWidget(
                                textEditingController: txtTelephone,
                                keyboardType: TextInputType.phone,
                                hintText: "Telefon* (Başında 0 olmadan)", //ipucu metni
                                obscureText: false, // yazılanlar gizlenmesin
                                inputFormatters: [maskFormatter],
                              ),
                              //-----------------------------Şifre textField'ı----------------------------------------
                              TextFieldWidget(
                                  textEditingController: txtPassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true, // yazılanlar gizlensin
                                  hintText: "Şifre*", //ipucu metni
                                  validator: (value) => (value)!.length > 2 ? "null" : "3 'ten küçük olmamalı"),
                              //----------------------------Şifre tekrar textField'ı---------------------------------
                              TextFieldWidget(
                                  textEditingController: txtPasswordAgain,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true, // yazılanlar gizlensin
                                  hintText: "Şifre tekrar*", //ipucu metni
                                  validator: (value) => (value)!.length > 2 ? "null" : "3 'ten küçük olmamalı"),
                              //-----------------------------------------------------------------------------------

                              Column(
                                children: [
                                  CheckboxListTile(
                                      value: checkedPrivacy,
                                      title: GestureDetector(
                                        child: const Text("Gizlilik Sözleşmesini kabul ediyorum",
                                            style: TextStyle(color: tertiaryColor, decoration: TextDecoration.underline)),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => const WebViewWidget(locationUrl: "https://she_wo.com/privacy.html")));
                                        },
                                      ),
                                      activeColor: tertiaryColor,
                                      checkColor: primaryColor,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      onChanged: (value) {
                                        setState(() {
                                          checkedPrivacy = value!;
                                        });
                                      }),
                                ],
                              ),
                              Material(
                                color: tertiaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                                child: MaterialButton(
                                    minWidth: deviceWidth(context) * 0.5,
                                    child: Text("Kayıt Ol",
                                        style: Theme.of(context).textTheme.button!.copyWith(color: white, fontFamily: contentFont, fontSize: 20)),
                                    onPressed: () async {
                                      final progressUHD = ProgressHUD.of(context);
                                      progressUHD!.show();
                                      if (txtNameSurname.text != null &&
                                          txtEMail.text != null &&
                                          txtTelephone.text != null &&
                                          txtPassword.text != null &&
                                          txtNameSurname.text != "" &&
                                          txtEMail.text != "" &&
                                          txtTelephone.text != "" &&
                                          txtPassword.text != "") {
                                        final userAddData =
                                            await userAddJsnFunc(txtNameSurname.text, txtEMail.text, txtTelephone.text, txtPassword.text, "", "");
                                        if (checkedPrivacy == true) {
                                          if (!mounted) return;
                                          if (txtPassword.text == txtPasswordAgain.text) {
                                            if (userAddData!.success == true) {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                            } else {
                                              showToast(context, userAddData.result!);
                                            }
                                          } else {
                                            showToast(context, "Girilen şifreler birbirinden farklı !");
                                          }
                                        } else {
                                          if (!mounted) return;
                                          showToast(context, "Gizlilik Sözleşmesini Onaylayınız !");
                                        }
                                      } else {
                                        showToast(context, "Eksik Alanları Doldurunuz !");
                                      }

                                      progressUHD.dismiss();
                                    }),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
