// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison, avoid_print, avoid_function_literals_in_foreach_calls, library_private_types_in_public_api
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:she_wo/JsnClass/company_list_jsn.dart';
import 'package:she_wo/JsnClass/company_profile.dart';
import 'package:she_wo/JsnClass/content_stream_detail_jsn.dart';
import 'package:she_wo/JsnClass/content_stream_jsn.dart';
import 'package:she_wo/JsnClass/like_jsn.dart';
import 'package:she_wo/providers/navigation_provider.dart';
import 'package:she_wo/providers/theme_data_provider.dart';
import 'package:she_wo/screens/company_profile_page.dart';
import 'package:she_wo/widgets/webview_widget.dart';
import 'package:she_wo/screens/home_detail_page.dart';
import 'package:she_wo/settings/connection.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/home_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:http/http.dart' as http;

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
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
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
                                        style: Theme.of(context).textTheme.headline6!.copyWith(color: tertiaryColor, fontFamily: leadingFont),
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

                            //------------------------------------Anasayfa Postları----------------------------------------
                            Expanded(
                              child: SmartRefresher(
                                controller: refreshController,
                                enablePullUp: true,
                                header: CustomHeader(
                                  builder: (c, m) => circularBasic,
                                ),
                                footer: CustomFooter(
                                  builder: (BuildContext context, LoadStatus? mode) {
                                    Widget body;
                                    if (mode == LoadStatus.idle) {
                                      body = circularBasic;
                                    } else if (mode == LoadStatus.loading) {
                                      body = circularBasic;
                                    } else if (mode == LoadStatus.failed) {
                                      body = const Text("Yükleme Hatası");
                                    } else if (mode == LoadStatus.canLoading) {
                                      body = circularBasic;
                                    } else if (mode == LoadStatus.noMore) {
                                      body = const Text("Hepsini gördün", style: TextStyle(color: secondaryColor));
                                    } else {
                                      body = circularBasic;
                                    }
                                    return Center(child: body);
                                  },
                                ),
                                onRefresh: () async {
                                  final result = await getHomeData(isRefresh: true);
                                  if (result) {
                                    refreshController.refreshCompleted();
                                  } else {
                                    refreshController.refreshFailed();
                                  }
                                },
                                onLoading: () async {
                                  final result = await getHomeData();
                                  if (result) {
                                    refreshController.loadComplete();
                                  } else {
                                    refreshController.isLoading;
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200, childAspectRatio: 3 / 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
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
                                          //---------------------------------------------------------------------------------------------------------------------------------------------------
                                          //--------------------------------------KONUM ICONBUTTON'I----------------------------------------------------------------------
                                          onPressedLocation: () {
                                            final progressHUD = ProgressHUD.of(context);
                                            progressHUD!.show();
                                            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                                builder: (context) => WebViewWidget(locationUrl: homeContent[index].googleAdressLink)));
                                            progressHUD.dismiss();
                                          },
                                          //-----------------------------------------------------------------------------------------------------------------------------------------------------
                                          //----------------------------------------LİKE BUTTON----------------------------------------
                                          likeButton: IconButton(
                                              icon: homeContent[index].liked
                                                  ? SvgPicture.asset("assets/icons/heart-focus.svg", height: 22, width: 22, color: secondaryColor)
                                                  : SvgPicture.asset("assets/icons/heart.svg", height: 25, width: 25, color: white),
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () async {
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                userIdData = prefs.getInt("userIdData");
                                                if (userIdData != 0) {
                                                  LikeJsn? likePostData = await likeJsnFunc(userIdData!, homeContent[index].campaingId);
                                                  print(likePostData!.success);
                                                  print(likePostData.result);
                                                  await refreshContentStream();
                                                } else {
                                                  if (!mounted) return;
                                                  showNotMemberAlert(context);
                                                }
                                              }),
                                          //--------------------------------------------------------------------------------------
                                          //----------------------------------------FAVORİTE BUTTON--------------------------------
                                          starButton: IconButton(
                                              icon: homeContent[index].favoriStatus
                                                  ? SvgPicture.asset("assets/icons/star-focus.svg", height: 22, width: 22, color: primaryColor)
                                                  : SvgPicture.asset("assets/icons/star.svg", height: 25, width: 25),
                                              onPressed: () async {
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                userIdData = prefs.getInt("userIdData");
                                                if (userIdData != 0) {
                                                  final favoriteAdd = await favoriteAddJsnFunc(userIdData!, homeContent[index].companyId);
                                                  print(favoriteAdd!.success);
                                                  print(favoriteAdd.result);
                                                  await refreshContentStream();
                                                } else {
                                                  if (!mounted) return;
                                                  showNotMemberAlert(context);
                                                }
                                              }),
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
                                          logoOnTap: () async {
                                            final progressUHD = ProgressHUD.of(context);
                                            progressUHD!.show();
                                            final CompanyProfileJsn? companyProfile = await companyListDetailJsnFunc(homeContent[index].companyId);
                                            if (!mounted) return;
                                            Navigator.of(context, rootNavigator: true)
                                                .push(MaterialPageRoute(builder: (context) => CompanyProfilePage(companyProfile: companyProfile)));
                                            progressUHD.dismiss();
                                          },
                                        );
                                      }),

                                  // ListView.builder(
                                  //     controller: NavigationProvider.of(context).screens[HOME_PAGE].scrollController,
                                  //     shrinkWrap: true,
                                  //     itemCount: homeContent.length,
                                  //     itemBuilder: (BuildContext context, int index) {

                                  //       //-------------------------------------------------------------------------------------------------------------------------
                                  //     }),
                                ),
                              ),
                            )
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
