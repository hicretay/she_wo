import 'package:she_wo/JsnClass/companyProfile.dart';
import 'package:she_wo/JsnClass/contentStreamDetailJsn.dart';
import 'package:she_wo/screens/homeDetailPage.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/webViewWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyProfilePage extends StatefulWidget {
  final CompanyProfileJsn? companyProfile;
  CompanyProfilePage({Key? key, this.companyProfile}) : super(key: key);

  @override
  _CompanyProfilePageState createState() => _CompanyProfilePageState(companyProfile: companyProfile);
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  late int userIdData;
  CompanyProfileJsn? companyProfile;

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
                      Row(
                        children: [
                          CircleAvatar(
                            //iconun çevresini saran yapı tasarımı
                            maxRadius: 20,
                            backgroundColor: Colors.white,
                            child: IconButton(
                                iconSize: iconSize,
                                icon: const Icon(Icons.arrow_back, color: primaryColor),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                }),
                          ),
                          const SizedBox(width: maxSpace),
                          SizedBox(
                            width: deviceWidth(context) * 0.7,
                            child: Text(
                              companyProfile!.result!.companyName!,
                              style: const TextStyle(overflow: TextOverflow.fade, fontFamily: contentFont, fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
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
                                color: white,
                                shape: BoxShape.circle,
                                image: DecorationImage(image: NetworkImage(companyProfile!.result!.companyLogo!)),
                              ),
                            ),
                            SizedBox(
                                width: deviceWidth(context) * 0.3,
                                child: Center(
                                    child: Text(companyProfile!.result!.companyName!,
                                        style: const TextStyle(color: white), overflow: TextOverflow.fade))),
                          ],
                        ),
                      ),
                      Row(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            const Text("Kampanya", style: TextStyle(color: white)),
                            SizedBox(height: deviceHeight(context) * 0.01),
                            Text(companyProfile!.result!.campaignCount.toString(), style: const TextStyle(color: white)),
                          ]),
                          SizedBox(width: deviceWidth(context) * 0.05),
                          Column(children: [
                            const Text("Beğeni", style: TextStyle(color: white)),
                            SizedBox(height: deviceHeight(context) * 0.01),
                            Text(companyProfile!.result!.likeCount.toString(), style: const TextStyle(color: white)),
                          ]),
                          SizedBox(width: deviceWidth(context) * 0.05),
                          Column(children: [
                            const Text("Favori", style: TextStyle(color: white)),
                            SizedBox(height: deviceHeight(context) * 0.01),
                            Text(companyProfile!.result!.favCount.toString(), style: const TextStyle(color: white)),
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
                            Text(companyProfile!.result!.companyPhone!)
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.1, top: deviceWidth(context) * 0.03),
                          child: Row(children: [
                            SizedBox(width: deviceWidth(context) * 0.17, child: const Text("WhatsApp")),
                            SizedBox(width: deviceWidth(context) * 0.05),
                            Text(companyProfile!.result!.companyPhone2!)
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.1, top: deviceWidth(context) * 0.03),
                          child: Row(children: [
                            SizedBox(width: deviceWidth(context) * 0.17, child: const Text("Web Adresi")),
                            SizedBox(width: deviceWidth(context) * 0.05),
                            Text(companyProfile!.result!.web!)
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.1, top: deviceWidth(context) * 0.03),
                          child: Row(children: [
                            SizedBox(width: deviceWidth(context) * 0.17, child: const Text("E-Posta")),
                            SizedBox(width: deviceWidth(context) * 0.05),
                            Text(companyProfile!.result!.eMail!)
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.1, top: deviceWidth(context) * 0.03),
                          child: Row(children: [
                            SizedBox(width: deviceWidth(context) * 0.17, child: const Text("Konum")),
                            SizedBox(width: deviceWidth(context) * 0.05),
                            GestureDetector(
                                child: const Text("Haritalarda açmak için tıklayınız",
                                    style: TextStyle(color: secondaryColor, decoration: TextDecoration.underline)),
                                onTap: () {
                                  final progressHUD = ProgressHUD.of(context);
                                  progressHUD!.show();
                                  Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(builder: (context) => WebViewWidget(locationUrl: companyProfile!.result!.googleAdressLink!)));
                                  progressHUD.dismiss();
                                })
                          ]),
                        ),
                        SizedBox(height: deviceHeight(context) * 0.01),
                        //----------------------------------------KAMPANYA LİSTESİ AKIŞI--------------------------------------------
                        Padding(
                          padding: const EdgeInsets.only(left: maxSpace, right: maxSpace),
                          child: GridView.builder(
                              //scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: companyProfile!.result!.campaignList!.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: (1 / .6),
                                crossAxisCount: 2,
                                mainAxisSpacing: minSpace,
                                crossAxisSpacing: minSpace,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Center(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(cardCurved)),
                                    child: GestureDetector(
                                      child: Container(
                                          width: deviceWidth(context),
                                          height: deviceHeight(context) * 0.15,
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              image:
                                                  DecorationImage(image: NetworkImage(companyProfile!.result!.campaignList![index].campaingLogo!))),
                                          child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: minSpace, right: minSpace),
                                                child: Text(companyProfile!.result!.campaignList![index].campaingName!),
                                              ))),
                                      onTap: () async {
                                        final progressUHD = ProgressHUD.of(context);
                                        progressUHD!.show();
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        userIdData = prefs.getInt("userIdData")!;
                                        final ContentStreamDetailJsn? homeDetailContent = await contentStreamDetailJsnFunc(
                                            companyProfile!.result!.id!, companyProfile!.result!.campaignList![index].campaingId!, userIdData);
                                        // "Detaylı Bilgi İçin" butouna basıldığında detay sayfasına yönlendirecek
                                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                            builder: (context) => HomeDetailPage(
                                                homeDetailContent: homeDetailContent!.result,
                                                campaingId: companyProfile!.result!.campaignList![index].campaingId,
                                                companyId: companyProfile!.result!.id,
                                                companyLogo: companyProfile!.result!.companyLogo,
                                                companyName: companyProfile!.result!.companyName!,
                                                contentTitle: companyProfile!.result!.campaignList![index].campaingName,
                                                googleAdressLink: companyProfile!.result!.googleAdressLink,
                                                companyPhone: companyProfile!.result!.companyPhone)));
                                        progressUHD.dismiss();
                                      },
                                    ),
                                  ),
                                );
                                // Container(
                                //    width: deviceWidth(context),
                                //   height: deviceHeight(context)*0.15,
                                //   child: Center(
                                //     child: ClipRRect(
                                //     borderRadius: BorderRadius.all(Radius.circular(cardCurved)),
                                //     child: Image.network(companyProfile.result.campaignList[index].campaingLogo,
                                //     fit: BoxFit.fill)
                                //     ),
                                //   ),
                                // );
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
