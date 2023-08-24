// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../JsnClass/content_stream_jsn.dart' as r;
import '../settings/consts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  final r.Result? homeContent;

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
    this.homeContent,
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
          aspectRatio: 1.6,
          child: Material(
            elevation: 5,
            borderRadius: const BorderRadius.all(Radius.circular(maxSpace)),
            child: Container(
              width: double.infinity, //genişlik: container genişliği kadar
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(maxSpace)),
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
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: widget.cardText != ''
                                  ? const BorderRadius.vertical(top: Radius.circular(maxSpace))
                                  : const BorderRadius.all(Radius.circular(maxSpace)),
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
                  if (widget.cardText != "" && widget.isCategoryWidget)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: deviceWidth(context),
                        padding: const EdgeInsets.all(minSpace),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(maxSpace)),
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
                    ),

                  //-------------------------------------ICONBUTTONLAR PANELİ----------------------------------------
                  if (!widget.isCategoryWidget)
                    SizedBox(
                        width: 300,
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
                              width: 300,
                              height: 60,
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
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      //? TODO Apiden Adres eklenecek
                                      const Expanded(
                                        child: Text(
                                          //widget.homeContent?.googleAdressLink ?? '',
                                          'Çınardere Mah, Oba Sk No:2/1-2-3-4, 34896 Pendik/İstanbul',
                                          style: TextStyle(fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: maxSpace),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  RatingBar(
                                                    updateOnDrag: false,
                                                    itemSize: 15,
                                                    initialRating: 4.5,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    ratingWidget: RatingWidget(
                                                        full: const Icon(Icons.star, color: Colors.black),
                                                        half: const Icon(Icons.star_half),
                                                        empty: const Icon(Icons.star_outline)),
                                                    itemPadding: EdgeInsets.zero,
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                  const Text(
                                                    //? TODO firma puanı eklenecek
                                                    '4.5 Harika',
                                                    style: TextStyle(fontSize: 10),
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
                ],
              ),
            ),
          ),
        ),
        //-----------------------------Post Containerı sonu------------------------------------
        if (!(widget.isCategoryWidget)) const SizedBox(height: maxSpace), //Post altı - divider arası boşluk
        // if (!(widget.isCategoryWidget))
        //   const Divider(
        //     //İki post arasında yer alan çizgi
        //     indent: 130.0,
        //     endIndent: 130.0,
        //     height: 1,
        //     color: passivePurple,
        //     thickness: 1.5,
        //   ),
        if (!(widget.isCategoryWidget)) const SizedBox(height: maxSpace), // Post üstü - divider arası boşluk
      ],
    );
  }
}
