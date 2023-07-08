// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:she_wo/JsnClass/company_list_jsn.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchPage extends StatefulWidget {
  static const route = "searchPage";
  const SearchPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController teSearch = TextEditingController();
  List allCompanies = [];
  List selectedCompanies = [];
  bool isFirstTime = true;

  Future<CompanyListJsn?> allCompaniesList() async {
    final CompanyListJsn? companyNewList = await companyListJsnFunc();
    if (mounted) {
      setState(() {
        allCompanies = companyNewList!.result!;
      });
    }
    return companyNewList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompanyListJsn?>(
        future: allCompaniesList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("HATA"),
            );
          } else {
            if (snapshot.hasData) {
              if (isFirstTime) {
                selectedCompanies = allCompanies;
                isFirstTime = false;
              }
              return Container(
                color: Colors.transparent,
                child: SafeArea(
                  top: false,
                  child: Scaffold(
                    body: ProgressHUD(
                      child: Builder(
                        builder: (context) => Container(
                          color: primaryColor,
                          child: Padding(
                            padding: EdgeInsets.only(top: deviceHeight(context) * 0.03),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
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
                                Padding(
                                  padding: EdgeInsets.only(top: deviceHeight(context) * 0.1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: defaultPadding,
                                          right: defaultPadding,
                                          bottom: defaultPadding,
                                        ),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Arama",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(color: tertiaryColor, fontFamily: leadingFont, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: minSpace),
                                        child: Container(
                                          decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: ListTile(
                                                  title: TextField(
                                                    cursorColor: tertiaryColor,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText: "Hizmet veya mekan arayın",
                                                      hintStyle: const TextStyle(color: Colors.grey),
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
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: minSpace),
                                        child: Container(
                                          decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: ListTile(
                                                  title: TextField(
                                                    cursorColor: tertiaryColor,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText: "Mevcut konum",
                                                      hintStyle: const TextStyle(color: Colors.grey),
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
                                                          icon: FaIcon(FontAwesomeIcons.locationArrow,
                                                              color: Theme.of(context).hintColor, size: 16, textDirection: TextDirection.ltr),
                                                          onPressed: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: deviceHeight(context) * 0.03),
                                        child: Material(
                                          color: tertiaryColor,
                                          borderRadius: BorderRadius.circular(16.0),
                                          //--------------------------------------------------GİRİŞ BUTONU---------------------------------------------------------------
                                          child: MaterialButton(
                                              minWidth: deviceWidth(context) * 0.35, //Buton minimum genişliği
                                              child: Text("UYGULA",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button!
                                                      .copyWith(color: white, fontFamily: contentFont, fontSize: 18, fontWeight: FontWeight.bold)),
                                              //-----------------------------GİRİŞ BUTONU ONPRESSEDİ---------------------------------------------
                                              onPressed: () {}),
                                          //-----------------------------------------------------------------------------------------------------------------------------
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return circularBasic;
            }
          }
        });
  }
}
