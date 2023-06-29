import 'package:she_wo/screens/loginPage.dart';
import 'package:she_wo/screens/registerPage.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class LogRegChoicePage extends StatefulWidget {
  static const route = "/logRegPage";
  const LogRegChoicePage({Key? key}) : super(key: key);

  @override
  _LogRegChoicePageState createState() => _LogRegChoicePageState();
}

class _LogRegChoicePageState extends State<LogRegChoicePage> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtForgetPassword = TextEditingController();
  bool isOnline = false;
  bool isPressed = false;

  @override
  void dispose() {
    txtUsername.dispose();
    txtPassword.dispose();
    super.dispose();
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
                            Material(
                              color: isPressed ? tertiaryColor : secondaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                              //--------------------------------------------------GİRİŞ BUTONU---------------------------------------------------------------
                              child: MaterialButton(
                                  minWidth: deviceWidth(context), //Buton minimum genişliği
                                  child: Text("Üye Girişi",
                                      style: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(color: isPressed ? white : tertiaryColor, fontFamily: contentFont, fontSize: 20)),
                                  //-----------------------------GİRİŞ BUTONU ONPRESSEDİ---------------------------------------------
                                  onPressed: () async {
                                    setState(() {
                                      isPressed = true;
                                    });
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                    Future.delayed(const Duration(seconds: 2)).whenComplete(() => setState(() {
                                          isPressed = false;
                                        }));
                                  }),
                              //-----------------------------------------------------------------------------------------------------------------------------
                            ),
                            const SizedBox(height: maxSpace),
                            Material(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                              //--------------------------------------------------GİRİŞ BUTONU---------------------------------------------------------------
                              child: MaterialButton(
                                  minWidth: deviceWidth(context), //Buton minimum genişliği
                                  child: Text("Kayıt Ol",
                                      style:
                                          Theme.of(context).textTheme.button!.copyWith(color: tertiaryColor, fontFamily: contentFont, fontSize: 20)),
                                  //-----------------------------GİRİŞ BUTONU ONPRESSEDİ---------------------------------------------
                                  onPressed: () async {
                                    setState(() {
                                      isPressed = true;
                                    });
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                                    Future.delayed(const Duration(seconds: 2)).whenComplete(() => setState(() {
                                          isPressed = false;
                                        }));
                                  }),
                              //-----------------------------------------------------------------------------------------------------------------------------
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
