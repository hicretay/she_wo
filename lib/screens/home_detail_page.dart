// ignore_for_file: avoid_print, library_private_types_in_public_api, no_logic_in_create_state, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_wo/JsnClass/content_stream_detail_jsn.dart';
import 'package:she_wo/model/appointment_model.dart';
import 'package:she_wo/screens/make_appointment_calendar_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/backleading_widget.dart';
import 'package:she_wo/widgets/textfield_widget.dart';

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

  double rating = 4.5;
  TextEditingController teComment = TextEditingController();
  bool isOpenKeyboard = false;

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

    isOpenKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: isOpenKeyboard
            ? null
            : SingleChildScrollView(
                child: FloatingActionButton.extended(
                    backgroundColor: tertiaryColor,
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      userIdData = prefs.getInt("userIdData")!;
                      if (userIdData != 0) {
                        AppointmentObject appointment =
                            AppointmentObject(companyId: companyId!, userId: userIdData, companyNameS: companyName!, campaignId: campaingId!);
                        if (!mounted) return;

                        Navigator.push(context, MaterialPageRoute(builder: (context) => MakeAppointmentCalendarPage(appointment: appointment)));

                        //Buton tıklandığında randevu al sayfasına yönlendirilecek
                      } else {
                        if (!mounted) return;
                        showNotMemberAlert(context);
                      }
                    },
                    label: const Text(
                      "Randevu Al",
                      style: TextStyle(color: primaryColor),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.calendar, size: 18, color: primaryColor)),
              ),
        body: ProgressHUD(
          child: Builder(
            builder: (context) => BackGroundContainer(
              child: Column(
                children: [
                  const BackLeadingWidget(
                    backColor: tertiaryColor,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //leading widgetı
                          Padding(
                            padding: const EdgeInsets.only(right: maxSpace, left: maxSpace, bottom: maxSpace, top: maxSpace / 2),
                            child: Center(
                              //-----------------------Carousel Containerı------------------------
                              child: SizedBox(
                                  width: double.infinity, //genişlik: container genişliği
                                  height: deviceHeight(context) * 0.3, //container yüksekliği
                                  child: homeDetailContent == null
                                      ? circularBasic
                                      : InteractiveViewer(
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
                                          ))),
                            ),
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //-----------------Butonların yer aldığı container--------------------
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(maxSpace)),
                                    ),
                                    width: double.infinity,
                                    height: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: maxSpace, top: minSpace),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                widget.companyName ?? '',
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            //? TODO Apiden Adres eklenecek
                                            const Expanded(
                                              child: Text(
                                                'Çınardere Mah, Oba Sk No:2/1, 34896 Pendik/İstanbul',
                                                style: TextStyle(fontSize: 13),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),

                                            const SizedBox(height: maxSpace),

                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: maxSpace),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        RatingBar(
                                                          itemSize: 20,
                                                          initialRating: 4.5,
                                                          direction: Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          ratingWidget: RatingWidget(
                                                              full: const Icon(Icons.star, color: Colors.black),
                                                              half: const Icon(Icons.star_half),
                                                              empty: const Icon(Icons.star_outline)),
                                                          itemPadding: EdgeInsets.zero,
                                                          onRatingUpdate: (value) {
                                                            setState(() {
                                                              rating = value;
                                                            });
                                                          },
                                                        ),
                                                        Text(
                                                          //? TODO firma puanı eklenecek
                                                          '${rating.toString()} Harika',
                                                          style: const TextStyle(fontSize: 10),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.remove_red_eye_sharp,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          //? TODO görüntülenme sayısı eklenecek
                                                          '500 Görüntülenme',
                                                          style: TextStyle(fontSize: 10),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: maxSpace)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  //------------------------------------------------------------------
                                ],
                              )),
                          //------------------Açıklama Metni----------------------
                          SingleChildScrollView(
                            child: Column(
                              children: [
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: maxSpace),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Yorumlar',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        ListView.builder(
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: ((context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: maxSpace),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const CircleAvatar(
                                                          backgroundColor: secondaryColor,
                                                          child: Text(
                                                            'H',
                                                            style: TextStyle(color: tertiaryColor, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        const SizedBox(width: maxSpace),
                                                        Column(
                                                          children: const [
                                                            Text(
                                                              'Hicret Ay',
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                            ),
                                                            Text(
                                                              '10.08.2023',
                                                              textAlign: TextAlign.left,
                                                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.grey),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(height: minSpace),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: RatingBar(
                                                        itemSize: 24,
                                                        initialRating: 4.5,
                                                        direction: Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        ratingWidget: RatingWidget(
                                                            full: const Icon(Icons.star, color: Colors.black),
                                                            half: const Icon(Icons.star_half),
                                                            empty: const Icon(Icons.star_outline)),
                                                        itemPadding: EdgeInsets.zero,
                                                        onRatingUpdate: (value) {},
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })),
                                      ],
                                    ),
                                  ),
                                ),
                                TextFieldWidget(
                                  hintText: "Yorumunuzu giriniz...",
                                  obscureText: false,
                                  inputFormatters: const [],
                                  keyboardType: TextInputType.text,
                                  textEditingController: teComment,
                                ),
                              ],
                            ),
                          ),
                          //------------------------------------------------------
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
    );
  }
}
