// ignore_for_file: avoid_print, library_private_types_in_public_api, no_logic_in_create_state, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_wo/model/appointment_model.dart';
import 'package:she_wo/model/comment_model.dart';
import 'package:she_wo/providers/theme_data_provider.dart';
import 'package:she_wo/screens/make_appointment_calendar_page.dart';
import 'package:she_wo/settings/consts.dart';
import 'package:she_wo/settings/functions.dart';
import 'package:she_wo/widgets/background_container.dart';
import 'package:she_wo/widgets/backleading_widget.dart';
import 'package:she_wo/widgets/textfield_widget.dart';
import 'package:she_wo/model/company_detail_model.dart' as d;

class HomeDetailPage extends StatefulWidget {
  final d.Result? homeDetailContent;
  final int? companyId;
  final String? companyLogo;
  final String? companyName;
  final String? contentTitle;
  final String? googleAdressLink;
  final String? companyPhone;
  final List<Result>? comments;
  const HomeDetailPage({
    Key? key,
    this.homeDetailContent,
    this.companyId,
    this.companyLogo,
    this.companyName,
    this.contentTitle,
    this.googleAdressLink,
    this.companyPhone,
    this.comments,
  }) : super(key: key);

  @override
  _HomeDetailPageState createState() => _HomeDetailPageState(
      homeDetailContent: homeDetailContent,
      companyId: companyId,
      companyLogo: companyLogo,
      companyName: companyName,
      contentTitle: contentTitle,
      googleAdressLink: googleAdressLink,
      companyPhone: companyPhone);
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  final d.Result? homeDetailContent;
  int? campaingId;
  int? companyId;
  String? companyLogo;
  String? companyName;
  String? contentTitle;
  String? googleAdressLink;
  String? companyPhone;
  late int userIdData;

  _HomeDetailPageState(
      {this.homeDetailContent, this.companyId, this.companyLogo, this.companyName, this.contentTitle, this.googleAdressLink, this.companyPhone});

  double rating = 4.5;
  double updateRating = 0;
  TextEditingController teComment = TextEditingController();
  bool isOpenKeyboard = false;

  @override
  Widget build(BuildContext context) {
    final transformationController = TransformationController();

    // Keyboard open - close controller
    isOpenKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    final provider = Provider.of<ThemeDataProvider>(context);

    // company comment
    List<Result>? newComments = provider.comments;

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
                        AppointmentObject appointment = AppointmentObject(companyId: companyId!, userId: userIdData, companyNameS: companyName!);
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
                                                      image: NetworkImage(homeDetailContent!.companyLogo.replaceAll('shewoo', 'estetikvitrini')))),
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
                                            Expanded(
                                              child: Text(
                                                homeDetailContent?.address ?? '',
                                                style: const TextStyle(fontSize: 13),
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
                                                        RatingBarIndicator(
                                                          rating: 4.5,
                                                          itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.black),
                                                          itemSize: 16,
                                                          direction: Axis.horizontal,
                                                          itemCount: 5,
                                                          itemPadding: EdgeInsets.zero,
                                                        ),
                                                        Text(
                                                          //? TODO firma puanı eklenecek
                                                          '${rating.toString()} Harika',
                                                          style: const TextStyle(fontSize: 10),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                    const Row(
                                                      children: [
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
                                          contentTitle ?? '',
                                          style: const TextStyle(fontSize: 22, color: tertiaryColor),
                                        ),
                                      ),
                                      Align(alignment: Alignment.bottomLeft, child: Text(homeDetailContent?.companyName ?? ''))

                                      //Text(homeDetailContent.first.campaingDetail, style: TextStyle(fontSize: 18, color: Theme.of(context).hintColor))),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: maxSpace, vertical: maxSpace),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (newComments != [])
                                          const Text(
                                            'Yorumlar',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        if (newComments != [])
                                          ListView.builder(
                                              itemCount: newComments?.length,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: ((context, index) {
                                                return Column(
                                                  children: [
                                                    const Divider(),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: maxSpace),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor: secondaryColor,
                                                                child: Text(
                                                                  newComments![index].userName.substring(0, 1),
                                                                  style: const TextStyle(color: tertiaryColor, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              const SizedBox(width: maxSpace),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    newComments[index].userName,
                                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                                  ),
                                                                  Text(
                                                                    newComments[index].registrationDate.toString(),
                                                                    textAlign: TextAlign.left,
                                                                    style: const TextStyle(
                                                                        fontWeight: FontWeight.normal, fontSize: 10, color: Colors.grey),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(height: minSpace),
                                                          Align(
                                                            alignment: Alignment.topLeft,
                                                            child: RatingBarIndicator(
                                                              rating: newComments[index].userPoint,
                                                              itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.black),
                                                              itemSize: 20,
                                                              direction: Axis.horizontal,
                                                              itemCount: 5,
                                                              itemPadding: EdgeInsets.zero,
                                                            ),
                                                          ),
                                                          const SizedBox(height: minSpace),
                                                          Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              newComments[index].comment,
                                                              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.grey),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              })),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    height: deviceHeight(context) * 0.2,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(color: secondaryColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextFieldWidget(
                                              height: deviceHeight(context) * 0.1,
                                              hintText: "Yorumunuzu giriniz...",
                                              obscureText: false,
                                              inputFormatters: const [],
                                              keyboardType: TextInputType.text,
                                              textEditingController: teComment,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RatingBar(
                                                  itemSize: 25,
                                                  initialRating: 0,
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
                                                      updateRating = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8),
                                                child: MaterialButton(
                                                  color: tertiaryColor,
                                                  minWidth: deviceWidth(context) * 0.2,
                                                  child: Text("Kaydet",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .copyWith(color: white, fontFamily: contentFont, fontSize: 15)),
                                                  //-----------------------------Kaydet BUTONU ONPRESSEDİ---------------------------------------------
                                                  onPressed: () async {
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    int userIdData = prefs.getInt("userIdData")!;

                                                    if (!mounted) return;
                                                    final progressHUD = ProgressHUD.of(context);
                                                    final commentData = await commentAddFunc(
                                                      userIdData,
                                                      widget.companyId!,
                                                      teComment.text,
                                                      updateRating,
                                                    );
                                                    if (commentData?.success == true) {
                                                      if (!mounted) return;
                                                      await showToast(context, "Yorum başarıyla kaydedildi!");
                                                      teComment.text = '';
                                                      final CommentModel? commentsModel = await commentListJsnFunc(widget.companyId!);
                                                      provider.setComments(commentsModel?.result);
                                                    } else {
                                                      if (!mounted) return;
                                                      await showToast(context, "Yorum kaydı başarısız!");
                                                      teComment.text = '';
                                                    }
                                                    setState(() {
                                                      updateRating = 0;
                                                    });

                                                    progressHUD?.dismiss();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 100),
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
