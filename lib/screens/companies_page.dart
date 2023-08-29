// ignore_for_file: avoid_print, library_private_types_in_public_api, no_logic_in_create_state

import 'package:she_wo/JsnClass/company_list_jsn.dart';
import 'package:she_wo/JsnClass/company_operation_jsn.dart';
import 'package:she_wo/model/appointment_model.dart';
import 'package:she_wo/screens/make_appointment_operation_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/backleading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompaniesPage extends StatefulWidget {
  final String? date;
  const CompaniesPage({Key? key, this.date}) : super(key: key);

  @override
  _CompaniesPageState createState() => _CompaniesPageState(date: date!);
}

class _CompaniesPageState extends State<CompaniesPage> {
  TextEditingController teSearch = TextEditingController();
  List allCompanies = [];
  List selectedCompanies = [];
  bool isFirstTime = true;
  String? date;

  _CompaniesPageState({this.date});

  Future<CompanyListJsn> allCompaniesList() async {
    final CompanyListJsn? companyNewList = await companyListJsnFunc();
    if (mounted) {
      setState(() {
        allCompanies = companyNewList!.result!;
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
                                      "firmalar",
                                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: tertiaryColor, fontFamily: leadingFont),
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
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
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
                                          ListView.separated(
                                            padding: const EdgeInsets.all(0),
                                            physics: const NeverScrollableScrollPhysics(),
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
                                                      child: Text(
                                                        selectedCompanies.isEmpty
                                                            ? allCompanies[index].companyName
                                                            : selectedCompanies[index].companyName,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontSize: 18, color: tertiaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    final progressHUD = ProgressHUD.of(context);
                                                    progressHUD!.show();
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    int? userIdData = prefs.getInt("userIdData");
                                                    //if(userIdData != 0){
                                                    AppointmentObject appointment = AppointmentObject(
                                                        companyId: selectedCompanies.isEmpty ? allCompanies[index].id : selectedCompanies[index].id,
                                                        userId: userIdData!,
                                                        companyNameS: selectedCompanies.isEmpty
                                                            ? allCompanies[index].companyName
                                                            : selectedCompanies[index].companyName,
                                                        campaignId: 0,
                                                        appointmentDate: date!);
                                                    final CompanyOperationJsn? companyOperation =
                                                        await companyOperationJsnFunc(appointment.companyId!);
                                                    if (!mounted) return;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => MakeAppointmentOperationPage(
                                                                companyOperation: companyOperation!.result, appointment: appointment)));
                                                    print(selectedCompanies.isEmpty
                                                        ? allCompanies[index].companyName
                                                        : selectedCompanies[index].companyName);
                                                    print(selectedCompanies.isEmpty ? allCompanies[index].id : selectedCompanies[index].id);
                                                    progressHUD.dismiss();
                                                    // }
                                                    // else{
                                                    //   showNotMemberAlert(context);
                                                    //   progressHUD.dismiss();
                                                    // }
                                                  },
                                                ),
                                              );
                                            },
                                            separatorBuilder: (BuildContext context, int index) {
                                              return const SizedBox(height: minSpace);
                                            },
                                          ),
                                          const SizedBox(height: maxSpace)
                                        ],
                                      ),
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
