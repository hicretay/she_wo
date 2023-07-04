// ignore_for_file: avoid_print, library_private_types_in_public_api, no_logic_in_create_state

import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_wo/JsnClass/company_profile.dart';
import 'package:she_wo/JsnClass/content_stream_detail_jsn.dart';
import 'package:she_wo/JsnClass/like_jsn.dart';
import 'package:she_wo/model/appointment_model.dart';
import 'package:she_wo/screens/company_profile_page.dart';
import 'package:she_wo/screens/make_appointment_calendar_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/backleading_widget.dart';
import 'package:she_wo/widgets/leading_row_widget.dart';
import 'package:she_wo/widgets/webview_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDetailPage extends StatefulWidget {
  final List? homeDetailContent;
  final int? campaingId;
  final int? companyId;
  final String? companyLogo;
  final String? companyName;
  final String? contentTitle;
  final String? googleAdressLink;
  final String? companyPhone;
  const HomeDetailPage(
      {Key? key,
      this.homeDetailContent,
      this.campaingId,
      this.companyId,
      this.companyLogo,
      this.companyName,
      this.contentTitle,
      this.googleAdressLink,
      this.companyPhone})
      : super(key: key);

  @override
  _HomeDetailPageState createState() => _HomeDetailPageState(
      homeDetailContent: homeDetailContent,
      campaingId: campaingId,
      companyId: companyId,
      companyLogo: companyLogo,
      companyName: companyName,
      contentTitle: contentTitle,
      googleAdressLink: googleAdressLink,
      companyPhone: companyPhone);
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  List? homeDetailContent;
  int? campaingId;
  int? companyId;
  String? companyLogo;
  String? companyName;
  String? contentTitle;
  String? googleAdressLink;
  String? companyPhone;

  late int userIdData;

  _HomeDetailPageState(
      {this.homeDetailContent,
      this.campaingId,
      this.companyId,
      this.companyLogo,
      this.companyName,
      this.contentTitle,
      this.googleAdressLink,
      this.companyPhone});
  Future homeDetailRefresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userIdData = prefs.getInt("userIdData")!;
    final ContentStreamDetailJsn? detailNewList = await contentStreamDetailJsnFunc(companyId!, campaingId!, userIdData);
    if (!mounted) return;
    setState(() {
      homeDetailContent = detailNewList!.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transformationController = TransformationController();
    //--------------------Slider Imageları-------------------
    List<dynamic> sliderImg = [];
    for (var item in homeDetailContent!.first.contentPictures) {
      //final transformationController = TransformationController();
      sliderImg.add(AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.fitWidth, image: NetworkImage(item.cPicture)),
              borderRadius: const BorderRadius.all(Radius.circular(maxSpace))),
        ),
      ));
    }
    //-------------------------------------------------------

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
                            "kampanyalar", //Büyük Başlık
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: tertiaryColor, fontFamily: leadingFont),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            companyName!,
                            style: const TextStyle(color: tertiaryColor),
                          ),
                        ),
                        const SizedBox(height: maxSpace)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        decoration: const BoxDecoration(
                          color: secondaryColor, //Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(cardCurved)), //Yalnızca dikeyde yuvarlatılmış
                        ),
                        child: FutureBuilder<dynamic>(
                            future: homeDetailRefresh(),
                            builder: (context, snapshot) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: maxSpace),
                                    LeadingRowWidget(
                                      companyName: companyName!,
                                      companyLogo: companyLogo!,
                                      leadingColor: Theme.of(context).hintColor,
                                      starButton: Container(),
                                      logoOnTap: () async {
                                        final progressUHD = ProgressHUD.of(context);
                                        progressUHD!.show();
                                        final CompanyProfileJsn? companyProfile = await companyListDetailJsnFunc(companyId!);
                                        if (!mounted) return;
                                        Navigator.of(context, rootNavigator: true)
                                            .push(MaterialPageRoute(builder: (context) => CompanyProfilePage(companyProfile: companyProfile)));
                                        progressUHD.dismiss();
                                      },
                                    ), //leading widgetı
                                    Padding(
                                      padding: const EdgeInsets.only(right: maxSpace, left: maxSpace, bottom: maxSpace, top: maxSpace / 2),
                                      child: Center(
                                        //-----------------------Carousel Containerı------------------------
                                        child: SizedBox(
                                            width: double.infinity, //genişlik: container genişliği
                                            height: deviceHeight(context) * 0.3, //container yüksekliği
                                            child: homeDetailContent == null
                                                ? circularBasic
                                                : // ana sayfa içeriği boş ise circular, ekli görsel sayısı 1 ise Image.network
                                                sliderImg.length == 1
                                                    ? InteractiveViewer(
                                                        panEnabled: false,
                                                        clipBehavior: Clip.none,
                                                        transformationController: transformationController,
                                                        onInteractionEnd: (details) {
                                                          setState(() {
                                                            transformationController.toScene(Offset.zero);
                                                          });
                                                        },
                                                        child: AspectRatio(
                                                          aspectRatio: 16 / 9,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.all(Radius.circular(maxSpace)),
                                                                image: DecorationImage(
                                                                    fit: BoxFit.fitWidth,
                                                                    image: NetworkImage(homeDetailContent!.first.contentPictures.first.cPicture))),
                                                          ),
                                                        ))
                                                    : //  ekli görsel sayısı 1den fazla ise carousel
                                                    InteractiveViewer(
                                                        panEnabled: false,
                                                        clipBehavior: Clip.none,
                                                        transformationController: transformationController,
                                                        onInteractionEnd: (details) {
                                                          setState(() {
                                                            transformationController.toScene(Offset.zero);
                                                          });
                                                        },
                                                        child: Carousel(
                                                            borderRadius: true,
                                                            radius: const Radius.circular(maxSpace),
                                                            boxFit: BoxFit.fitWidth,
                                                            autoplay: false,
                                                            animationCurve: Curves.bounceInOut, // animasyon efekti
                                                            animationDuration: const Duration(milliseconds: 1000), // animasyon süresi
                                                            dotSize: 6.0, //Nokta büyüklüğü
                                                            dotIncreasedColor: primaryColor, // Seçili sayfa noktası rengi
                                                            dotColor: secondaryColor,
                                                            dotBgColor: Colors.transparent, //Carousel alt bar rengi
                                                            dotPosition: DotPosition.bottomCenter, // Noktaların konumu
                                                            dotVerticalPadding: 10.0, //noktaların dikey uzaklığı
                                                            showIndicator: true, // sayfa geçişi noktaları gösterilsin mi = true
                                                            indicatorBgPadding: 7.0, // noktaların Carousel zemininden uzaklığı
                                                            images: sliderImg),
                                                      )),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        //-----------------Alt Header-----------------------
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(minSpace),
                                              //-----------------------Beğeni iconButton'ı----------------------------
                                              child: CircleAvatar(
                                                //Beğeni butonunu kaplayan circleAvatar yapısı
                                                maxRadius: deviceWidth(context) * 0.05,
                                                backgroundColor: homeDetailContent!.first.liked
                                                    ? primaryColor
                                                    : tertiaryColor, // seçili ise koyu, değilse açık renk verildi
                                                child: IconButton(
                                                    icon: homeDetailContent!.first.liked
                                                        ? const Icon(LineIcons.heart, color: tertiaryColor)
                                                        : const Icon(LineIcons.heart, color: darkWhite),
                                                    onPressed: () async {
                                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                                      userIdData = prefs.getInt("userIdData")!;
                                                      if (userIdData != 0) {
                                                        LikeJsn? likePostData = await likeJsnFunc(userIdData, campaingId!);
                                                        print(likePostData!.success);
                                                        print(likePostData.result);
                                                        await homeDetailRefresh();
                                                      } else {
                                                        if (!mounted) return;
                                                        showNotMemberAlert(context);
                                                      }
                                                    }),
                                              ),
                                            ),

                                            // //-----------------------Paylaşım iconButton'ı----------------------------
                                            //         Padding(
                                            //           padding: const EdgeInsets.all(minSpace),
                                            //           child: IconButton(
                                            //                 padding    : EdgeInsets.zero,
                                            //                 constraints: BoxConstraints(),
                                            //                 icon       : Icon(Icons.share_outlined,
                                            //                 color      : primaryColor,
                                            //                 size       : iconSize),
                                            //                 onPressed  : () {}),
                                            //         ),
                                            // //------------------------------------------------------------------------
                                            //----------------------İletişim iconButton'ı-----------------------------
                                            Padding(
                                              padding: const EdgeInsets.all(minSpace),
                                              child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  icon: const Icon(LineIcons.phone, color: tertiaryColor, size: iconSize),
                                                  onPressed: () async {
                                                    dynamic number = companyPhone; // arama ekranına yönlendirme
                                                    launchUrl(Uri(path: "tel://$number"));
                                                  }),
                                            ),
                                            //------------------------------------------------------------------------
                                            //----------------------Konum iconButton'ı-------------------------------
                                            Padding(
                                              padding: const EdgeInsets.all(minSpace),
                                              child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  icon: const Icon(LineIcons.locationArrow, color: tertiaryColor, size: iconSize),
                                                  onPressed: () async {
                                                    final progressUHD = ProgressHUD.of(context);
                                                    progressUHD!.show();
                                                    Navigator.of(context, rootNavigator: true)
                                                        .push(MaterialPageRoute(builder: (context) => WebViewWidget(locationUrl: googleAdressLink!)));
                                                    progressUHD.dismiss();
                                                  }),
                                            ),
                                            //------------------------------------------------------------------------
                                          ],
                                        ),

                                        //-------------------------RANDEVU AL BUTONU----------------------------
                                        homeDetailContent!.first.appointmentStatus == true
                                            ? Material(
                                                color: tertiaryColor,
                                                borderRadius: BorderRadius.circular(30.0),
                                                child: MaterialButton(
                                                  minWidth: deviceWidth(context) * 0.4, //Buton minimum genişliği
                                                  onPressed: () async {
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    userIdData = prefs.getInt("userIdData")!;
                                                    if (userIdData != 0) {
                                                      AppointmentObject appointment = AppointmentObject(
                                                          companyId: companyId!,
                                                          userId: userIdData,
                                                          companyNameS: companyName!,
                                                          campaignId: campaingId!);
                                                      if (!mounted) return;
                                                      final progressHUD = ProgressHUD.of(context);
                                                      progressHUD!.show();
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => MakeAppointmentCalendarPage(appointment: appointment)));
                                                      progressHUD.dismiss();

                                                      //Buton tıklandığında randevu al sayfasına yönlendirilecek
                                                    } else {
                                                      if (!mounted) return;
                                                      showNotMemberAlert(context);
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      //----------------------------Buton Metni------------------------------------------
                                                      Text("Randevu Al", style: Theme.of(context).textTheme.button!.copyWith(color: white)),
                                                      //---------------------------------------------------------------------------------
                                                      const SizedBox(width: 10), //butondaki Text ve icon arası boşluk
                                                      const Icon(LineIcons.arrowRight, color: primaryColor),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: deviceWidth(context) * 0.4,
                                              ),
                                      ],
                                    ),
                                    const SizedBox(height: maxSpace), // Alt Header ve beğeni metni arasındaki boşluk
                                    Padding(
                                      padding: const EdgeInsets.only(left: maxSpace),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.favorite, // Beğeni İcon'ı
                                              size: iconSize,
                                              color: tertiaryColor),
                                          const SizedBox(width: minSpace),
                                          Text("${homeDetailContent!.first.likeCount} kişi tarafından beğenildi",
                                              style: const TextStyle(color: tertiaryColor)),
                                          // counter ile gösterilecek beğeni sayısı
                                        ],
                                      ),
                                    ),
                                    //------------------Açıklama Metni----------------------
                                    Padding(
                                      padding: const EdgeInsets.all(maxSpace),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              contentTitle!,
                                              style: const TextStyle(fontSize: 22, color: tertiaryColor),
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Html(
                                                  data: homeDetailContent!.first
                                                      .campaingDetail)), //Text(homeDetailContent.first.campaingDetail, style: TextStyle(fontSize: 18, color: Theme.of(context).hintColor))),
                                        ],
                                      ),
                                    ),
                                    //------------------------------------------------------
                                  ],
                                ),
                              );
                            })),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
