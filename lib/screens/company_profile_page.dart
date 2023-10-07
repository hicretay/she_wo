// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state
import 'package:she_wo/model/company_detail_model.dart';
import 'package:she_wo/screens/home_detail_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/webview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../widgets/backleading_widget.dart';

class CompanyProfilePage extends StatefulWidget {
  final CompanyDetailModel? companyProfile;
  const CompanyProfilePage({Key? key, this.companyProfile}) : super(key: key);

  @override
  _CompanyProfilePageState createState() => _CompanyProfilePageState(companyProfile: companyProfile);
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  late int userIdData;
  CompanyDetailModel? companyProfile;

  _CompanyProfilePageState({this.companyProfile});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ProgressHUD(
        child: Builder(
          builder: (context) => BackGroundContainer(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackLeadingWidget(
                        text: companyProfile!.result.companyName,
                        backColor: tertiaryColor,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: deviceWidth(context) * 0.05, left: deviceWidth(context) * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              width: deviceWidth(context) * 0.2,
                              height: deviceWidth(context) * 0.2,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.5),
                                color: white,
                                shape: BoxShape.circle,
                                image:
                                    DecorationImage(image: NetworkImage(companyProfile!.result.companyLogo.replaceAll('shewoo', 'estetikvitrini'))),
                              ),
                            ),
                            SizedBox(
                                width: deviceWidth(context) * 0.3,
                                child: Center(
                                    child:
                                        Text(companyProfile!.result.companyName, style: const TextStyle(color: white), overflow: TextOverflow.fade))),
                          ],
                        ),
                      ),
                      Row(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            const Text("Kampanya", style: TextStyle(color: tertiaryColor)),
                            SizedBox(height: deviceHeight(context) * 0.01),
                            Text(companyProfile!.result.campaignCount.toString(), style: const TextStyle(color: tertiaryColor)),
                          ]),
                          SizedBox(width: deviceWidth(context) * 0.05),
                          Column(children: [
                            const Text("Beğeni", style: TextStyle(color: tertiaryColor)),
                            SizedBox(height: deviceHeight(context) * 0.01),
                            Text(companyProfile!.result.likeCount.toString(), style: const TextStyle(color: tertiaryColor)),
                          ]),
                          SizedBox(width: deviceWidth(context) * 0.05),
                          Column(children: [
                            const Text("Favori", style: TextStyle(color: tertiaryColor)),
                            SizedBox(height: deviceHeight(context) * 0.01),
                            Text(companyProfile!.result.favCount.toString(), style: const TextStyle(color: tertiaryColor)),
                          ])
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight(context) * 0.01),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(cardCurved)), color: white),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        //-----------------------------------------ŞİRKET BİLGİLERİ ---------------------------------------------
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.1, top: deviceWidth(context) * 0.03),
                          child: Row(children: [
                            SizedBox(width: deviceWidth(context) * 0.17, child: const Text("Telefon")),
                            SizedBox(width: deviceWidth(context) * 0.05),
                            Text(companyProfile!.result.companyPhone)
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.1, top: deviceWidth(context) * 0.03),
                          child: Row(children: [
                            SizedBox(width: deviceWidth(context) * 0.17, child: const Text("WhatsApp")),
                            SizedBox(width: deviceWidth(context) * 0.05),
                            Text(companyProfile!.result.companyPhone2)
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.1, top: deviceWidth(context) * 0.03),
                          child: Row(children: [
                            SizedBox(width: deviceWidth(context) * 0.17, child: const Text("Web Adresi")),
                            SizedBox(width: deviceWidth(context) * 0.05),
                            Text(companyProfile!.result.web)
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.1, top: deviceWidth(context) * 0.03),
                          child: Row(children: [
                            SizedBox(width: deviceWidth(context) * 0.17, child: const Text("E-Posta")),
                            SizedBox(width: deviceWidth(context) * 0.05),
                            Text(companyProfile!.result.eMail)
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.1, top: deviceWidth(context) * 0.03),
                          child: Row(children: [
                            SizedBox(width: deviceWidth(context) * 0.17, child: const Text("Konum")),
                            SizedBox(width: deviceWidth(context) * 0.05),
                            GestureDetector(
                                child: const Text("Haritalarda açmak için tıklayınız",
                                    style: TextStyle(color: passivePurple, decoration: TextDecoration.underline)),
                                onTap: () {
                                  final progressHUD = ProgressHUD.of(context);
                                  progressHUD!.show();
                                  Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(builder: (context) => WebViewWidget(locationUrl: companyProfile!.result.googleAdressLink)));
                                  progressHUD.dismiss();
                                })
                          ]),
                        ),
                        SizedBox(height: deviceHeight(context) * 0.03),
                        //----------------------------------------KAMPANYA LİSTESİ AKIŞI--------------------------------------------
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.1, top: deviceWidth(context) * 0.03),
                          child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: companyProfile!.result.campaignList.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: (1 / .6),
                                crossAxisCount: 2,
                                mainAxisSpacing: minSpace,
                                crossAxisSpacing: minSpace,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Center(
                                  child: GestureDetector(
                                    child: Container(
                                        width: deviceWidth(context),
                                        height: deviceHeight(context) * 0.15,
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius: const BorderRadius.all(Radius.circular(cardCurved)),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    companyProfile!.result.campaignList[index].campaingLogo.replaceAll('shewoo', 'estetikvitrini')))),
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: minSpace, right: minSpace),
                                              child: Text(
                                                companyProfile!.result.campaignList[index].campaingName,
                                                style: const TextStyle(),
                                              ),
                                            ))),
                                    onTap: () async {
                                      final progressUHD = ProgressHUD.of(context);
                                      progressUHD!.show();
                                      final CompanyDetailModel? homeDetailContent = await companyDetailFunc(companyProfile!.result.id);

                                      if (!mounted) return;
                                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                          builder: (context) => HomeDetailPage(
                                              homeDetailContent: homeDetailContent!.result,
                                              campaingId: companyProfile!.result.campaignList[index].campaingId,
                                              companyId: companyProfile!.result.id,
                                              companyLogo: companyProfile!.result.companyLogo.replaceAll('shewoo', 'estetikvitrini'),
                                              companyName: companyProfile!.result.companyName,
                                              contentTitle: companyProfile!.result.campaignList[index].campaingName,
                                              googleAdressLink: companyProfile!.result.googleAdressLink,
                                              companyPhone: companyProfile!.result.companyPhone)));
                                      progressUHD.dismiss();
                                    },
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(height: defaultPadding),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
