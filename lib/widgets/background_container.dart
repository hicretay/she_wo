import 'package:she_wo/settings/consts.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BackGroundContainer extends StatefulWidget {
  // Uygulama arka planındaki renk geçişini oluşturuyor
  // favoritePage, locationPage sayfalarında kullanıldı
  final Widget? child;
  const BackGroundContainer({Key? key, this.child}) : super(key: key);

  @override
  _BackGroundContainerState createState() => _BackGroundContainerState();
}

class _BackGroundContainerState extends State<BackGroundContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: primaryColor
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.topRight,
          //   colors: widget.colors
          // ),
          ),
      child: widget.child,
    );
  }
}
