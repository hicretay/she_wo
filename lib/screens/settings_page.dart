import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/webview_widget.dart';
import 'login_page.dart';
import '../settings/consts.dart';
import '../widgets/background_container.dart';
import '../widgets/list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static const route = "settingsPage";
  const SettingsPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String user = "";
  bool isAdmin = false;

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? newuser = prefs.getString("namesurname");
    setState(() {
      user = newuser!;
    });
  }

  getIsAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? newAdminData = prefs.getBool("isAdmin");
    setState(() {
      isAdmin = newAdminData!;
    });
  }

  @override
  void initState() {
    getUserName();
    getIsAdmin();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: ProgressHUD(
            child: Builder(
              builder: (context) => BackGroundContainer(
                child: Column(
                  children: [
                    SizedBox(height: deviceHeight(context) * 0.03),
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: maxSpace),
                                child: Column(
                                  children: [
                                    Text("Profil",
                                        style: Theme.of(context).textTheme.displaySmall!.copyWith(color: tertiaryColor, fontFamily: leadingFont)),
                                    Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(user, style: const TextStyle(color: tertiaryColor, fontSize: 16))),
                                    SizedBox(height: deviceHeight(context) * 0.01),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Column(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: tertiaryColor,
                                child: CircleAvatar(
                                  backgroundColor: secondaryColor,
                                  radius: 30,
                                  child: Icon(Icons.person, color: tertiaryColor, size: 40),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(cardCurved)), //Yalnızca dikeyde yuvarlatılmış
                        ),
                        child: ListView(
                          controller: NavigationProvider.of(context).screens[SETTINGS_PAGE].scrollController,
                          padding: const EdgeInsets.all(0),
                          children: [
                            const SizedBox(height: defaultPadding),

                            const SizedBox(height: minSpace), // Post üstü - divider arası boşluk
                            ListTileWidget(
                              text: "Lisans Sözleşmesi",
                              child: const LineIcon(LineIcons.fileContract, color: primaryColor),
                              onTap: () {
                                final progressHUD = ProgressHUD.of(context);
                                progressHUD!.show();
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(builder: (context) => const WebViewWidget(locationUrl: "https://she_wo.com/license.html")));
                                progressHUD.dismiss();
                              },
                            ),
                            ListTileWidget(
                              text: "Kullanım Sözleşmesi",
                              child: const LineIcon(LineIcons.fileSignature, color: primaryColor),
                              onTap: () {
                                final progressHUD = ProgressHUD.of(context);
                                progressHUD!.show();
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(builder: (context) => const WebViewWidget(locationUrl: "https://she_wo.com/usage.html")));
                                progressHUD.dismiss();
                              },
                            ),
                            ListTileWidget(
                              text: "Gizlilik Bildirimi",
                              child: const LineIcon(LineIcons.file, color: primaryColor),
                              onTap: () {
                                final progressHUD = ProgressHUD.of(context);
                                progressHUD!.show();
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(builder: (context) => const WebViewWidget(locationUrl: "https://she_wo.com/privacy.html")));
                                progressHUD.dismiss();
                              },
                            ),
                            ListTileWidget(
                              text: "She Wo Hakkında",
                              child: const LineIcon(LineIcons.infoCircle, color: primaryColor),
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(builder: (context) => const WebViewWidget(locationUrl: "https://she_wo.com/About.html")));
                              },
                            ),

                            ListTileWidget(
                                text: "Uygulamadan çıkış yap",
                                child: const Icon(Icons.exit_to_app, color: primaryColor),
                                onTap: () async {
                                  final progressUHD = ProgressHUD.of(context);
                                  progressUHD!.show();
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  // ignore: use_build_context_synchronously
                                  Provider.of<NavigationProvider>(context, listen: false).setCurrentTab(0);
                                  // shared preferences nesnelerinin silinmesi
                                  prefs.remove("user");
                                  prefs.remove("pass");
                                  prefs.remove("userIdData");
                                  prefs.remove("namesurname");
                                  prefs.remove("isFirstLogin");
                                  prefs.remove("isAdmin");
                                  if (!mounted) return;
                                  Navigator.of(context, rootNavigator: true)
                                      .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                                  progressUHD.dismiss();
                                }),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
