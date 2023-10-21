// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_wo/JsnClass/login_jsn.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/textfield_widget.dart';

import '../providers/navigation_provider.dart';
import '../settings/root.dart';

class LoginPage extends StatefulWidget {
  static const route = "/loginPage";
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtForgetPassword = TextEditingController();
  bool isOnline = false;

  @override
  void dispose() {
    txtUsername.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      txtUsername.text = 'emre@aeyazilim.com';
      txtPassword.text = '1';
    }
  }

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
                      SizedBox(height: deviceHeight(context) * 0.12),
                      //--------------------------giriş ikonu----------------------------------
                      SizedBox(
                          width: deviceWidth(context),
                          height: deviceWidth(context) * 0.5,
                          child: Center(child: Image.asset("assets/images/shewo_logo.png"))),
                      //------------------------------------------------------------------
                      // dikdörtgen olan 1228 3443  ----- tümü 3787 2985 -------- sadece yazı olan 10529 1639(6.42)
                      SizedBox(height: deviceHeight(context) * 0.12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            //--------------------Kullanıcı textField'ı---------------------
                            TextFieldWidget(
                              textEditingController: txtUsername,
                              keyboardType: TextInputType.emailAddress,
                              hintText: "Telefon veya E-Posta", //ipucu metni
                              obscureText: false, // yazılanlar gizlenmesin
                            ),
                            //-------------------------Şifre textField'ı------------------------
                            TextFieldWidget(
                              textEditingController: txtPassword,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true, // yazılanlar gizlensin
                              hintText: "Şifre", //ipucu metni
                            ),
                            //------------------------------------------------------------------
                            const SizedBox(height: minSpace),
                            Material(
                              color: tertiaryColor,
                              borderRadius: BorderRadius.circular(16.0),
                              //--------------------------------------------------GİRİŞ BUTONU---------------------------------------------------------------
                              child: MaterialButton(
                                  minWidth: deviceWidth(context) * 0.3, //Buton minimum genişliği
                                  child: Text("Giriş",
                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(color: white, fontFamily: contentFont, fontSize: 20)),
                                  //-----------------------------GİRİŞ BUTONU ONPRESSEDİ---------------------------------------------
                                  onPressed: () async {
                                    final progressHUD = ProgressHUD.of(context);
                                    progressHUD!.show();
                                    String username = txtUsername.text; // Kullanıcı Adı TextField'ının texti = username
                                    String password = txtPassword.text; // Şifre TextField'ının texti = password
                                    if (username != "" && password != "") {
                                      //--------------------------------USER DATASI DOLDURULMASI---------------------------
                                      final LoginJsn? userData = await loginJsnFunc(username, password);
                                      if (userData!.success == true) {
                                        // Giriş kontrolü, succes
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString("namesurname", userData.result!.nameSurname!);
                                        prefs.setString("user", username);
                                        prefs.setString("pass", password);
                                        prefs.setBool("isAdmin", userData.result!.admin!);
                                        prefs.setInt("userIdData", userData.result!.id!);
                                        if (!mounted) return;

                                        if (prefs.getString("isFirstLogin") != null) {
                                          if (!mounted) return;
                                          NavigationProvider.of(context).setTab(HOME_PAGE);
                                          Navigator.pop(context, false);
                                        } else {
                                          if (!mounted) return;
                                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const Root()));
                                        }
                                        showToast(context, "Giriş Başarılı!");
                                        progressHUD.dismiss();
                                      } else {
                                        if (!mounted) return;
                                        showAlert(context, "Kullanıcı adı veya şifre yanlış!");
                                      }
                                    } else {
                                      showAlert(context, "Kullanıcı adı veya şifre boş geçilemez!");
                                    }

                                    progressHUD.dismiss();
                                  }),
                              //-----------------------------------------------------------------------------------------------------------------------------
                            ),

                            const SizedBox(height: minSpace),

                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                color: tertiaryColor,
                                thickness: 0.7,
                              ),
                            ),

                            TextButton(
                              child: const Text("Şifremi Unuttum", style: TextStyle(color: tertiaryColor, fontFamily: contentFont, fontSize: 16)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ProgressHUD(
                                        child: Builder(
                                          builder: (context) => AlertDialog(
                                            title: const Center(child: Text("SIFREMI UNUTTUM", style: TextStyle(fontFamily: leadingFont))),
                                            content: SizedBox(
                                              height: 75,
                                              child: Column(
                                                children: [
                                                  const Text("Lütfen E-Posta adresinizi giriniz: "),
                                                  const SizedBox(height: minSpace),
                                                  TextField(
                                                    controller: txtForgetPassword,
                                                    keyboardType: TextInputType.emailAddress,
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.all(maxSpace),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(cardCurved),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                MaterialButton(
                                                    color: tertiaryColor,
                                                    child: const Text("Gönder",
                                                        style: TextStyle(fontFamily: leadingFont, color: white)), // fotoğraf çekilmeye devam edilecek
                                                    onPressed: () async {
                                                      final progressHUD = ProgressHUD.of(context);
                                                      progressHUD!.show();
                                                      final forgetPasswordData = await forgetPasswordJsnFunc(txtForgetPassword.text.trim());
                                                      if (forgetPasswordData!.success == true) {
                                                        if (!mounted) return;
                                                        showToast(context, "Lütfen mail aresinizi kontrol ediniz !");
                                                      } else {
                                                        if (!mounted) return;
                                                        showToast(context, "Bir hata oluştu !");
                                                      }
                                                      if (!mounted) return;
                                                      Navigator.of(context).pop();
                                                      progressHUD.dismiss();
                                                    }),
                                              ]),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ]),
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
