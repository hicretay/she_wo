import 'package:she_wo/JsnClass/login_jsn.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:flutter/foundation.dart';

String? usernameP;
String? passwordP;

class JsonDataProvider with ChangeNotifier {
  LoginJsn userDataProvider = LoginJsn();

  getLoginData(context) async {
    userDataProvider = (await loginJsnFunc(usernameP!, passwordP!))!;
    notifyListeners();
  }
}
