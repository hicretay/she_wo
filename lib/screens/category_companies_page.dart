// ignore_for_file: avoid_print, library_private_types_in_public_api, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_wo/model/appointment_model.dart';
import 'package:she_wo/screens/make_appointment_calendar_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/backleading_widget.dart';

import '../model/top_favorite_model.dart';

class CategoryCompaniesPage extends StatefulWidget {
  final int categoryId;
  final String categoryname;
  const CategoryCompaniesPage({Key? key, required this.categoryId, required this.categoryname}) : super(key: key);

  @override
  _CategoryCompaniesPageState createState() => _CategoryCompaniesPageState();
}

class _CategoryCompaniesPageState extends State<CategoryCompaniesPage> {
  TextEditingController teSearch = TextEditingController();
  List allCompanies = [];
  List selectedCompanies = [];
  bool isFirstTime = true;
  // String? date;

  _CategoryCompaniesPageState();

  Future<TopFavoritesModel> allCompaniesList() async {
    final TopFavoritesModel? companyNewList = await categoryCompanyListJsnFunc(widget.categoryId);
    if (mounted) {
      setState(() {
        allCompanies = companyNewList!.result;
      });
    }
    return companyNewList!;
  }

  @override
  void initState() {
    super.initState();
    allCompaniesList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: allCompaniesList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("HATA"));
          } else {
            if (snapshot.hasData) {
              if (isFirstTime) {
                selectedCompanies = allCompanies;
                isFirstTime = false;
              }
              return SafeArea(
                child: Scaffold(
                  body: ProgressHUD(
                    child: Builder(
                      builder: (context) => BackGroundContainer(
                        child: Column(
                          children: [
                            const BackLeadingWidget(
                              backColor: tertiaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: maxSpace),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.categoryname,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: tertiaryColor, fontFamily: leadingFont, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "randevu alınacak firmayı seçiniz",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(height: maxSpace)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  decoration: const BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(cardCurved)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: maxSpace),
                                    child: Column(
                                      children: [
                                        if (!(selectedCompanies.isEmpty && allCompanies.isEmpty))
                                          ListTile(
                                            visualDensity: const VisualDensity(vertical: -4),
                                            dense: true,
                                            title: TextField(
                                              controller: teSearch,
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
                                                      selectedCompanies.clear();
                                                      setState(() {
                                                        for (var element in allCompanies) {
                                                          if (element.companyName.toLowerCase().contains(teSearch.text.toLowerCase())) {
                                                            selectedCompanies.add(element);
                                                          }
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                selectedCompanies.clear();
                                                setState(() {
                                                  for (var element in allCompanies) {
                                                    if (element.companyName.toLowerCase().contains(teSearch.text.toLowerCase())) {
                                                      selectedCompanies.add(element);
                                                    }
                                                  }
                                                });
                                              },
                                              onChanged: (value) {
                                                selectedCompanies.clear();
                                                setState(() {
                                                  for (var element in allCompanies) {
                                                    if (element.companyName.toLowerCase().contains(teSearch.text.toLowerCase())) {
                                                      selectedCompanies.add(element);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        if (selectedCompanies.isEmpty && allCompanies.isEmpty)
                                          const Center(
                                            child: Text('Uygun firma bulunamadı !'),
                                          ),
                                        Expanded(
                                          child: ListView.separated(
                                            padding: const EdgeInsets.all(0),
                                            shrinkWrap: true,
                                            itemCount: selectedCompanies.isEmpty ? allCompanies.length : selectedCompanies.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
                                                child: InkWell(
                                                  child: Container(
                                                    height: deviceHeight(context) * 0.06,
                                                    width: deviceWidth(context) * 0.06,
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                      color: primaryColor,
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                                            child: Container(
                                                              alignment: Alignment.topLeft,
                                                              width: deviceWidth(context) * 0.15,
                                                              height: deviceWidth(context) * 0.15,
                                                              decoration: BoxDecoration(
                                                                color: white,
                                                                shape: BoxShape.circle,
                                                                image: DecorationImage(
                                                                  image: NetworkImage(selectedCompanies.isEmpty
                                                                      ? allCompanies[index].companyLogo
                                                                      : selectedCompanies[index].companyLogo),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              selectedCompanies.isEmpty
                                                                  ? allCompanies[index].companyName
                                                                  : selectedCompanies[index].companyName,
                                                              overflow: TextOverflow.ellipsis,
                                                              textAlign: TextAlign.center,
                                                              style: const TextStyle(fontSize: 18, color: tertiaryColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    final progressHUD = ProgressHUD.of(context);
                                                    progressHUD!.show();
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    int userIdData = prefs.getInt("userIdData")!;
                                                    if (userIdData != 0) {
                                                      AppointmentObject appointment = AppointmentObject(
                                                        companyId: selectedCompanies.isEmpty ? allCompanies[index].id : selectedCompanies[index].id,
                                                        userId: userIdData,
                                                        companyNameS: selectedCompanies.isEmpty
                                                            ? allCompanies[index].companyName
                                                            : selectedCompanies[index].companyName,
                                                      );
                                                      if (!mounted) return;

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => MakeAppointmentCalendarPage(appointment: appointment),
                                                        ),
                                                      );

                                                      //Buton tıklandığında randevu al sayfasına yönlendirilecek
                                                    }
                                                    progressHUD.dismiss();
                                                  },
                                                ),
                                              );
                                            },
                                            separatorBuilder: (BuildContext context, int index) {
                                              return const SizedBox(height: minSpace);
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: maxSpace)
                                      ],
                                    ),
                                  )),
                            ),
                          ],
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
