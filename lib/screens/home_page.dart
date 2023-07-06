// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison, avoid_print, avoid_function_literals_in_foreach_calls, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_wo/JsnClass/company_list_jsn.dart';
import 'package:she_wo/JsnClass/content_stream_detail_jsn.dart';
import 'package:she_wo/JsnClass/content_stream_jsn.dart';
import 'package:she_wo/providers/navigation_provider.dart';
import 'package:she_wo/providers/theme_data_provider.dart';
import 'package:she_wo/screens/home_detail_page.dart';
import 'package:she_wo/settings/connection.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/home_container_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/category_model.dart';
import '../settings/consts.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  static const route = "/homePage";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List homeContent = [];
  int pageIndex = 1;
  int totalPage = 1;
  bool textFieldTapped = false;
  List? companyContent;
  int? userIdData;
  bool? isLogin;

  TextEditingController teSearch = TextEditingController();

  List allCompanies = [];
  List selectedCompanies = [];

//---------------------------INTERNET KONTROLÜ STREAM'I------------------------------
  // ignore: cancel_subscriptions
  StreamSubscription? _connectionChangeStream;
  bool isOffline = false;
//-----------------------------------------
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<bool> getHomeData({bool isRefresh = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userIdData = prefs.getInt("userIdData");
    if (isRefresh) {
      pageIndex = 1;
    } else {
      if (pageIndex > totalPage) {
        refreshController.loadNoData();
        return false;
      }
    }

    final response = await http.post(Uri.parse("${url}ContentStream/List"), body: '{"userId":$userIdData,"page":$pageIndex}', headers: header);

    if (response.statusCode == 200) {
      final result = contentStreamJsnFromJson(response.body);
      if (isRefresh) {
        homeContent = result.result!;
      } else {
        homeContent.addAll(result.result!);
      }
      pageIndex++;
      totalPage = result.totalPage!;

      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ThemeDataProvider>(context, listen: false).loadTheme();
    companyStoryList();
    setState(() {});
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);

    getAllCategories();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  void getAllCategories() async {
    await getHomeData();
  }

  @override
  void dispose() {
    _connectionChangeStream!.cancel();
    super.dispose();
  }

  Future companyStoryList() async {
    final CompanyListJsn? companyNewList = await companyListJsnFunc();
    setState(() {
      companyContent = companyNewList!.result;
    });
  }

  Future refreshContentStream() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userIdData = prefs.getInt("userIdData")!;
    final ContentStreamJsn? companyNewList = await contentStreamJsnFunc(userIdData!, 0);
    setState(() {
      homeContent = companyNewList!.result!;
    });
  }

//-------------------------------------------------------------------------------------

  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: ProgressHUD(
              child: (homeContent != null && companyContent != null)
                  ? Builder(
                      builder: (context) => BackGroundContainer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //-----------------------------BAŞLIK-------------------------------
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: deviceWidth(context) * 0.1),
                                child: SizedBox(
                                  height: deviceWidth(context) * 0.25,
                                  child: Center(
                                    child: Image.asset("assets/images/shewo_logo.png"),
                                  ),
                                ),
                              ),
                            ),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: defaultPadding),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        "Keşfet",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(color: tertiaryColor, fontFamily: leadingFont, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Text(
                                        "Farklı yerlere rezervasyon yap",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontFamily: leadingFont),
                                      ),
                                    ),
                                    const SizedBox(height: minSpace),
                                    SizedBox(
                                      child: Text(
                                        "Popüler Kategoriler",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(color: tertiaryColor, fontFamily: leadingFont, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //____________________________________Arama Kısmı____________________________________________

                            Padding(
                              padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: minSpace),
                              child: Container(
                                decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: ListTile(
                                        visualDensity: const VisualDensity(vertical: -4),
                                        dense: true,
                                        title: TextField(
                                          cursorColor: tertiaryColor,
                                          controller: teSearch,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "Ara",
                                            hintStyle: const TextStyle(color: tertiaryColor),
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            filled: true,
                                            fillColor: secondaryColor,
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(cardCurved)),
                                            ),
                                            icon: CircleAvatar(
                                              maxRadius: 15,
                                              backgroundColor: secondaryColor,
                                              child: IconButton(
                                                iconSize: iconSize,
                                                icon: FaIcon(FontAwesomeIcons.search,
                                                    color: Theme.of(context).hintColor, size: 16, textDirection: TextDirection.ltr),
                                                onPressed: () {
                                                  NavigationProvider.of(context).setTab(HOME_PAGE);
                                                },
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            selectedCompanies.clear();
                                            setState(() {
                                              allCompanies.forEach((element) {
                                                if (element.companyName.toLowerCase().contains(teSearch.text.toLowerCase())) {
                                                  selectedCompanies.add(element);
                                                }
                                              });
                                            });
                                          },
                                          onChanged: (value) {
                                            selectedCompanies.clear();
                                            setState(() {
                                              allCompanies.forEach((element) {
                                                if (element.companyName.toLowerCase().contains(teSearch.text.toLowerCase())) {
                                                  selectedCompanies.add(element);
                                                }
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                                      child: GridView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 218,
                                            childAspectRatio: 3 / 2,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 16,
                                            mainAxisExtent: 120,
                                          ),
                                          itemCount: homeCategoryList.length,
                                          itemBuilder: (BuildContext ctx, index) {
                                            return HomeContainerWidget(
                                              isPopular: true,
                                              isCategoryWidget: true,
                                              companyName: homeCategoryList[index].leading,
                                              contentPicture: homeCategoryList[index].image,
                                              //--------------------------------------------------------"DETAYLI BİLGİ İÇİN" BUTONU-------------------------------------------------------------
                                              onPressed: () async {
                                                final progressUHD = ProgressHUD.of(context);
                                                progressUHD!.show();
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                userIdData = prefs.getInt("userIdData");
                                                final ContentStreamDetailJsn? homeDetailContent = await contentStreamDetailJsnFunc(
                                                    homeContent[index].companyId, homeContent[index].campaingId, userIdData!);
                                                // "Detaylı Bilgi İçin" butouna basıldığında detay sayfasına yönlendirecek
                                                if (!mounted) return;
                                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                                    builder: (context) => HomeDetailPage(
                                                        homeDetailContent: homeDetailContent!.result,
                                                        campaingId: homeContent[index].campaingId,
                                                        companyId: homeContent[index].companyId,
                                                        companyLogo: homeContent[index].companyLogo,
                                                        companyName: homeContent[index].companyName,
                                                        contentTitle: homeContent[index].contentTitle,
                                                        googleAdressLink: homeContent[index].googleAdressLink,
                                                        companyPhone: homeContent[index].companyPhone.toString())));
                                                progressUHD.dismiss();
                                              },
                                              //----------------------------------------------------------------------------------------------------------------------
                                              homeDetailOntap: () async {
                                                final progressUHD = ProgressHUD.of(context);
                                                progressUHD!.show();
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                userIdData = prefs.getInt("userIdData");
                                                final ContentStreamDetailJsn? homeDetailContent = await contentStreamDetailJsnFunc(
                                                    homeContent[index].companyId, homeContent[index].campaingId, userIdData!);
                                                // "Detaylı Bilgi İçin" butouna basıldığında detay sayfasına yönlendirecek
                                                if (!mounted) return;
                                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                                    builder: (context) => HomeDetailPage(
                                                        homeDetailContent: homeDetailContent!.result,
                                                        campaingId: homeContent[index].campaingId,
                                                        companyId: homeContent[index].companyId,
                                                        companyLogo: homeContent[index].companyLogo,
                                                        companyName: homeContent[index].companyName,
                                                        contentTitle: homeContent[index].contentTitle,
                                                        googleAdressLink: homeContent[index].googleAdressLink,
                                                        companyPhone: homeContent[index].companyPhone.toString())));
                                                progressUHD.dismiss();
                                              },
                                            );
                                          }),
                                    ),

                                    const SizedBox(height: maxSpace),

                                    Padding(
                                      padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: minSpace),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Tüm Kategoriler',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(color: tertiaryColor, fontFamily: leadingFont, fontWeight: FontWeight.bold),
                                          )),
                                    ),

                                    //------------------------------------Anasayfa Postları----------------------------------------
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                                      child: GridView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 200,
                                            childAspectRatio: 3 / 2,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 16,
                                            mainAxisExtent: 120,
                                          ),
                                          itemCount: homeContent.length,
                                          itemBuilder: (BuildContext ctx, index) {
                                            return HomeContainerWidget(
                                              isCategoryWidget: true,
                                              companyLogo: homeContent[index].companyLogo,
                                              companyName: homeContent[index].companyName,
                                              contentPicture: homeContent[index].contentPicture,
                                              cardText: homeContent[index].contentTitle,
                                              pinColor: primaryColor,
                                              onPressedPhone: () async {
                                                dynamic number = homeContent[index].companyPhone.toString(); // arama ekranına yönlendirme
                                                launchUrl(Uri(path: "tel://$number"));
                                              },
                                              //--------------------------------------------------------"DETAYLI BİLGİ İÇİN" BUTONU-------------------------------------------------------------
                                              onPressed: () async {
                                                final progressUHD = ProgressHUD.of(context);
                                                progressUHD!.show();
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                userIdData = prefs.getInt("userIdData");
                                                final ContentStreamDetailJsn? homeDetailContent = await contentStreamDetailJsnFunc(
                                                    homeContent[index].companyId, homeContent[index].campaingId, userIdData!);
                                                // "Detaylı Bilgi İçin" butouna basıldığında detay sayfasına yönlendirecek
                                                if (!mounted) return;
                                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                                    builder: (context) => HomeDetailPage(
                                                        homeDetailContent: homeDetailContent!.result,
                                                        campaingId: homeContent[index].campaingId,
                                                        companyId: homeContent[index].companyId,
                                                        companyLogo: homeContent[index].companyLogo,
                                                        companyName: homeContent[index].companyName,
                                                        contentTitle: homeContent[index].contentTitle,
                                                        googleAdressLink: homeContent[index].googleAdressLink,
                                                        companyPhone: homeContent[index].companyPhone.toString())));
                                                progressUHD.dismiss();
                                              },
                                              //----------------------------------------------------------------------------------------------------------------------
                                              homeDetailOntap: () async {
                                                final progressUHD = ProgressHUD.of(context);
                                                progressUHD!.show();
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                userIdData = prefs.getInt("userIdData");
                                                final ContentStreamDetailJsn? homeDetailContent = await contentStreamDetailJsnFunc(
                                                    homeContent[index].companyId, homeContent[index].campaingId, userIdData!);
                                                // "Detaylı Bilgi İçin" butouna basıldığında detay sayfasına yönlendirecek
                                                if (!mounted) return;
                                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                                    builder: (context) => HomeDetailPage(
                                                        homeDetailContent: homeDetailContent!.result,
                                                        campaingId: homeContent[index].campaingId,
                                                        companyId: homeContent[index].companyId,
                                                        companyLogo: homeContent[index].companyLogo,
                                                        companyName: homeContent[index].companyName,
                                                        contentTitle: homeContent[index].contentTitle,
                                                        googleAdressLink: homeContent[index].googleAdressLink,
                                                        companyPhone: homeContent[index].companyPhone.toString())));
                                                progressUHD.dismiss();
                                              },
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : circularBasic),
        ),
      ),
    );
  }
}
