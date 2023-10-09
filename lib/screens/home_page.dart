// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:she_wo/model/comment_model.dart';
import 'package:she_wo/model/company_detail_model.dart';
import 'package:she_wo/model/home_categories_model.dart' as h;
import 'package:she_wo/model/top_favorite_model.dart' as f;
import 'package:she_wo/providers/theme_data_provider.dart';
import 'package:she_wo/screens/search_page.dart';

import '../settings/consts.dart';
import '../settings/functions.dart';
import '../widgets/background_container.dart';
import '../widgets/home_container_widget.dart';
import 'home_detail_page.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  static const route = "/homePage";

  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<h.Result> homeContent = [];
  List<h.Result> populerContent = [];
  List<f.Result> topFavoriteContent = [];
  bool isLoading = false;

  TextEditingController teSearch = TextEditingController();

  List selectedCompanies = [];

//-----------------------------------------

  Future getHomeData() async {
    final response = await http.post(Uri.parse("https://service.shewoo.com/api/CategoryOperation/List"), body: '{}', headers: header);

    if (response.statusCode == 200) {
      setState(() {
        homeContent = h.homeCategoriesModelFromJson(response.body).result;
      });
    } else {
      print('an error occured');
    }
  }

  Future getPopulerData() async {
    final response = await http.post(Uri.parse("https://service.shewoo.com/api/CategoryOperation/PopularList"), body: '{}', headers: header);

    if (response.statusCode == 200) {
      setState(() {
        populerContent = h.homeCategoriesModelFromJson(response.body).result;
      });
    } else {
      print('an error occured');
    }
  }

  Future getTopFavoriteData() async {
    final response = await http.post(Uri.parse("https://service.shewoo.com/api/CompanyList/TopFavorite"), body: '{}', headers: header);

    if (response.statusCode == 200) {
      setState(() {
        topFavoriteContent = f.topFavoritesModelFromJson(response.body).result.reversed.toList();
      });
    } else {
      print('an error occured');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  Future getAllData() async {
    setState(() {
      isLoading = true;
    });
    await getHomeData();
    await getPopulerData();
    await getTopFavoriteData();
    setState(() {
      isLoading = false;
    });
  }

//-------------------------------------------------------------------------------------

  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeDataProvider>(context);
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: ProgressHUD(
              child: isLoading == false
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
                                            .headlineSmall!
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
                                            .titleLarge!
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
                                          readOnly: true,
                                          cursorColor: tertiaryColor,
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
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
                                                },
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
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
                                          itemCount: populerContent.length,
                                          itemBuilder: (BuildContext ctx, index) {
                                            return HomeContainerWidget(
                                              isPopular: true,
                                              isCategoryWidget: true,
                                              companyName: populerContent[index].categoryName,
                                              contentPicture: populerContent[index].categoryLogo,
                                              homeDetailOntap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
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
                                                .titleLarge!
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
                                              companyName: homeContent[index].categoryName,
                                              contentPicture: homeContent[index].categoryLogo,
                                              cardText: homeContent[index].categoryName,
                                              homeDetailOntap: () async {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
                                              },
                                            );
                                          }),
                                    ),
                                    const SizedBox(height: minSpace),
                                    Padding(
                                      padding: const EdgeInsets.only(left: defaultPadding),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          child: Text(
                                            "En Favoriler",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(color: tertiaryColor, fontFamily: leadingFont, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 250,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics: const ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: topFavoriteContent.length,
                                            itemBuilder: (BuildContext ctx, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(right: maxSpace),
                                                child: SizedBox(
                                                  width: 300,
                                                  child: HomeContainerWidget(
                                                    isCategoryWidget: false,
                                                    companyName: topFavoriteContent[index].companyName,
                                                    contentPicture: topFavoriteContent[index].companyLogo.replaceAll('shewoo', 'estetikvitrini'),
                                                    cardText: topFavoriteContent[index].companyName,
                                                    homeDetailOntap: () async {
                                                      final progressUHD = ProgressHUD.of(context);
                                                      progressUHD!.show();
                                                      final CompanyDetailModel? homeDetailContent =
                                                          await companyDetailFunc(topFavoriteContent[index].id);

                                                      final CommentModel? commentsModel = await commentListJsnFunc(topFavoriteContent[index].id);
                                                      provider.setComments(commentsModel?.result);

                                                      if (!mounted) return;
                                                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                                          builder: (context) => HomeDetailPage(
                                                                homeDetailContent: homeDetailContent!.result,
                                                                companyId: homeDetailContent.result.id,
                                                                companyLogo:
                                                                    homeDetailContent.result.companyLogo.replaceAll('shewoo', 'estetikvitrini'),
                                                                companyName: homeDetailContent.result.companyName,
                                                                contentTitle: homeDetailContent.result.campaignList[index].campaingName,
                                                                googleAdressLink: homeDetailContent.result.googleAdressLink,
                                                                companyPhone: homeDetailContent.result.companyPhone,
                                                                comments: commentsModel?.result,
                                                              )));
                                                      progressUHD.dismiss();
                                                    },
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
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
