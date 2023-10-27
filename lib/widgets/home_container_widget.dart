// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:she_wo/model/top_favorite_model.dart' as t;

import '../settings/consts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeContainerWidget extends StatefulWidget {
  //homePage sayfasında post görünümü oluşturulmasında kullanıldı
  final String? cardText; // resimde yer alacak metin
  final String? companyName; // resimde yer alacak metin
  final String? contentPicture;
  final VoidCallback? onPressed; // detaylı bilgi butonu olayı
  final Widget? child, likeButton;
  final VoidCallback? onPressedLocation, onPressedPhone, homeDetailOntap, logoOnTap;
  final bool isCategoryWidget;
  final bool? isPopular;
  final double? commentsAvg;
  final t.Result? pageData;

  const HomeContainerWidget({
    Key? key,
    this.cardText,
    this.onPressed,
    this.child,
    this.companyName,
    this.contentPicture,
    this.onPressedLocation,
    this.onPressedPhone,
    this.likeButton,
    this.homeDetailOntap,
    this.logoOnTap,
    required this.isCategoryWidget,
    this.isPopular,
    this.commentsAvg,
    this.pageData,
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
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    widget.contentPicture!.replaceAll('shewoo', 'estetikvitrini'),
                                  ),
                                  onError: (error, stackTrace) {
                                    const Icon(Icons.image);
                                  },
                                ),
                              ),
                            ))),
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
                                      Expanded(
                                        child: Text(
                                          widget.pageData?.companyAddress ?? '',
                                          style: const TextStyle(fontSize: 10),
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
                                                    initialRating: widget.commentsAvg ?? 0,
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
                                                  Text(
                                                    (widget.commentsAvg ?? 0).toString(),
                                                    style: const TextStyle(fontSize: 10),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.remove_red_eye_sharp,
                                                    size: 15,
                                                  ),
                                                  const SizedBox(width: 1),
                                                  Text(
                                                    '${widget.pageData?.viewsNumber} Görüntülenme',
                                                    style: const TextStyle(fontSize: 10),
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
