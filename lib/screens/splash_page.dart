// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:she_wo/JsnClass/login_jsn.dart';
import 'package:she_wo/providers/theme_data_provider.dart';
import 'package:she_wo/screens/log_reg_choice_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/settings/root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  static const route = "/splashPage";

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var connectivityResult = Connectivity().checkConnectivity();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      Provider.of<ThemeDataProvider>(context, listen: false).loadTheme();
      if (await connectivityResult != ConnectivityResult.none) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? user = prefs.getString("user");
        String? pass = prefs.getString("pass");

        if (user == null) {
          if (!mounted) return;
          Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LogRegChoicePage()), (route) => false);
        } else {
          // ignore: unused_local_variable
          final LoginJsn? userData = await loginJsnFunc(user, pass!);
          if (!mounted) return;
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const Root()));
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("İnternet bağlantınızı kontrol ediniz.", style: TextStyle(fontFamily: contentFont)),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                          color: primaryColor,
                          child: const Text("Kapat", style: TextStyle(fontFamily: leadingFont)),
                          onPressed: () async {
                            exit(0);
                          }),
                    ],
                  ),
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SizedBox(
        child: Image.asset("assets/images/shewo_logo.png"),
      ),
    );
  }
}
