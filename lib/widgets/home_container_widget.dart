// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import '../settings/consts.dart';

class HomeContainerWidget extends StatefulWidget {
  //homePage sayfasında post görünümü oluşturulmasında kullanıldı
  final String? cardText; // resimde yer alacak metin
  final String? companyLogo; // resimde yer alacak metin
  final String? companyName; // resimde yer alacak metin
  final String? contentPicture;
  final VoidCallback? onPressed; // detaylı bilgi butonu olayı
  final Widget? child, likeButton, starButton;
  final Color? pinColor;
  final VoidCallback? onPressedLocation, onPressedPhone, homeDetailOntap, logoOnTap;
  final bool isCategoryWidget;
  final bool? isPopular;

  const HomeContainerWidget({
    Key? key,
    this.cardText,
    this.onPressed,
    this.child,
    this.pinColor,
    this.companyLogo,
    this.companyName,
    this.contentPicture,
    this.onPressedLocation,
    this.onPressedPhone,
    this.likeButton,
    this.starButton,
    this.homeDetailOntap,
    this.logoOnTap,
    required this.isCategoryWidget,
    this.isPopular,
  }) : super(key: key);

  @override
  _HomeContainerWidgetState createState() => _HomeContainerWidgetState();
}

class _HomeContainerWidgetState extends State<HomeContainerWidget> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final transformationController = TransformationController();
    return Column(
      children: [
        //-----------------------------Postu çevreleyecek container yapısı-----------------------------
        AspectRatio(
          aspectRatio: 1.5,
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(maxSpace),
            child: Container(
              width: double.infinity, //genişlik: container genişliği kadar
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(maxSpace), //container kenarlarının yuvarlatılması
              ),
              child: Column(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: widget.homeDetailOntap,
                      child: InteractiveViewer(
                        clipBehavior: Clip.none,
                        transformationController: transformationController,
                        onInteractionEnd: (details) {
                          setState(() {
                            transformationController.toScene(Offset.zero);
                          });
                        },
                        child: AspectRatio(
                          aspectRatio: 2.3,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(maxSpace)),
                                image: (widget.isPopular ?? false)
                                    ? DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: AssetImage(widget.contentPicture!),
                                      )
                                    : DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: NetworkImage(widget.contentPicture!),
                                      )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget.cardText != ""
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: deviceWidth(context),
                            padding: const EdgeInsets.all(minSpace),
                            decoration: const BoxDecoration(
                              color: primaryColor,
                            ),
                            child: Text(
                              widget.companyName ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: contentFont,
                                color: tertiaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  //-------------------------------------ICONBUTTONLAR PANELİ----------------------------------------
                  if (!(widget.isCategoryWidget))
                    Padding(
                      padding: const EdgeInsets.only(left: minSpace, right: minSpace),
                      child: SizedBox(
                          width: deviceWidth(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end, //Tüm widgetlar container altına konumlandırılsın
                            children: [
                              //-----------------Butonların yer aldığı container--------------------
                              Container(
                                decoration: const BoxDecoration(
                                  color: secondaryTransparentColor, // Colors.white,
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(maxSpace)),
                                ),
                                width: double.infinity, // genişlik: container kadar
                                height: 40,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          //------------------------------BEĞEN ICONBUTTONI-------------------------------
                                          widget.likeButton ?? const SizedBox(),
                                          //------------------------------------------------------------------------------
                                          // //------------------------------PAYLAŞ ICONBUTTONI---------------------------
                                          //   IconButton(icon: Icon(Icons.share_outlined,color: primaryColor),
                                          //   onPressed: () {}),
                                          // //---------------------------------------------------------------------------
                                          //------------------------------İLETİŞİM ICONBUTTONI----------------------------
                                          IconButton(
                                              padding: const EdgeInsets.all(0),
                                              icon: SvgPicture.asset("assets/icons/telephone.svg", height: 22, width: 22, color: darkWhite),
                                              onPressed: widget.onPressedPhone),
                                          //------------------------------------------------------------------------------
                                          //-----------------------------KONUM ICONBUTTONI--------------------------------
                                          IconButton(
                                              padding: const EdgeInsets.all(0),
                                              icon: SvgPicture.asset("assets/icons/pin.svg", height: 22, width: 22, color: darkWhite),
                                              onPressed: widget.onPressedLocation)
                                          //------------------------------------------------------------------------------
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: widget.onPressed,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Detaylı Bilgi İçin",
                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: darkWhite),
                                          ),
                                          const Icon(
                                            LineIcons.arrowRight, // sağa ok ikonu
                                            color: darkWhite,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //------------------------------------------------------------------
                            ],
                          )),
                    ),
                  //-------------------------------------------------------------------------------------------------
                  // Post ana containeri - resim containerı arası alt boşluk
                  const SizedBox(height: maxSpace),
                ],
              ),
            ),
          ),
        ),
        //-----------------------------Post Containerı sonu------------------------------------
        if (!(widget.isCategoryWidget)) const SizedBox(height: maxSpace), //Post altı - divider arası boşluk
        if (!(widget.isCategoryWidget))
          const Divider(
            //İki post arasında yer alan çizgi
            indent: 130.0,
            endIndent: 130.0,
            height: 1,
            color: passivePurple,
            thickness: 1.5,
          ),
        if (!(widget.isCategoryWidget)) const SizedBox(height: maxSpace), // Post üstü - divider arası boşluk
      ],
    );
  }
}
