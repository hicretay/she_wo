import 'package:provider/provider.dart';
import 'package:she_wo/JsnClass/company_profile.dart';
import 'package:she_wo/providers/navigation_provider.dart';
import 'package:she_wo/screens/appointment_operation_page.dart';
import 'package:she_wo/screens/campaign_operation_page.dart';
import 'package:she_wo/screens/company_information_page.dart';
import 'package:she_wo/screens/location_page.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/webview_widget.dart';
import 'package:she_wo/screens/login_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                                        style: Theme.of(context).textTheme.headline3!.copyWith(color: tertiaryColor, fontFamily: leadingFont)),
                                    Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(user, style: const TextStyle(color: tertiaryColor, fontSize: 16))),
                                    SizedBox(height: deviceHeight(context) * 0.01),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: const [
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
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(cardCurved)), //Yalnızca dikeyde yuvarlatılmış
                        ),
                        child: ListView(
                          controller: NavigationProvider.of(context).screens[SETTINGS_PAGE].scrollController,
                          padding: const EdgeInsets.all(0),
                          children: [
                            const SizedBox(height: defaultPadding),
                            isAdmin == true
                                ? Column(children: [
                                    ListTileWidget(
                                      text: "Kampanya İşlemleri",
                                      child: const FaIcon(FontAwesomeIcons.tags, size: 16, color: primaryColor),
                                      onTap: () async {
                                        final progressHUD = ProgressHUD.of(context);
                                        progressHUD!.show();
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        // ignore: unused_local_variable
                                        int? userIdData = prefs.getInt("userIdData");
                                        final CompanyProfileJsn? companyProfile = await companyListDetailJsnFunc(1); //userIdData
                                        if (!mounted) return;
                                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                            builder: (context) => CampaignOperationPage(
                                                  companyProfile: companyProfile,
                                                )));
                                        progressHUD.dismiss();
                                      },
                                    ),
                                    ListTileWidget(
                                      text: "Gelen Randevular",
                                      child: const FaIcon(FontAwesomeIcons.calendarCheck, size: 18, color: primaryColor),
                                      onTap: () {
                                        final progressHUD = ProgressHUD.of(context);
                                        progressHUD!.show();
                                        if (!mounted) return;
                                        Navigator.of(context, rootNavigator: true)
                                            .push(MaterialPageRoute(builder: (context) => const AppointmentOperationPage()));
                                        progressHUD.dismiss();
                                      },
                                    ),
                                    ListTileWidget(
                                      text: "Firma Bilgileri",
                                      child: const FaIcon(FontAwesomeIcons.questionCircle, size: 18, color: primaryColor),
                                      onTap: () async {
                                        final progressHUD = ProgressHUD.of(context);
                                        progressHUD!.show();
                                        final CompanyProfileJsn? companyProfile = await companyListDetailJsnFunc(1); // companyContent![index].id
                                        if (!mounted) return;
                                        Navigator.of(context, rootNavigator: true)
                                            .push(MaterialPageRoute(builder: (context) => CompanyInformationPage(companyProfile: companyProfile)));
                                        progressHUD.dismiss();
                                      },
                                    ),
                                    const SizedBox(height: maxSpace), //Post altı - divider arası boşluk
                                    const Divider(
                                      //İki post arasında yer alan çizgi
                                      indent: 100.0,
                                      endIndent: 100.0,
                                      height: 1,
                                      color: secondaryColor,
                                      thickness: 1.5,
                                    ),
                                  ])
                                : Container(),
                            const SizedBox(height: minSpace), // Post üstü - divider arası boşluk
                            ListTileWidget(
                              text: "Lisans Sözleşmesi",
                              child: LineIcon(LineIcons.fileContract, color: primaryColor),
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
                              child: LineIcon(LineIcons.fileSignature, color: primaryColor),
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
                              child: LineIcon(LineIcons.file, color: primaryColor),
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
                              child: LineIcon(LineIcons.infoCircle, color: primaryColor),
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(builder: (context) => const WebViewWidget(locationUrl: "https://she_wo.com/About.html")));
                              },
                            ),
                            ListTileWidget(
                              text: "Favori Konumlar",
                              child: SvgPicture.asset("assets/icons/haritanoktası.svg", height: 25, width: 25, color: primaryColor),
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString("isFirstLogin", "Favori Konumlar");
                                if (!mounted) return;
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const LocationPage()));
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
                                  prefs.remove("isLoggedIn");
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
