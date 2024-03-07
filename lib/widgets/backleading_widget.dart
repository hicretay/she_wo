import 'package:she_wo/settings/consts.dart';
import 'package:flutter/material.dart';

class BackLeadingWidget extends StatelessWidget {
  final Color? backColor;
  final String? text;
  const BackLeadingWidget({
    Key? key,
    this.backColor,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: maxSpace, bottom: maxSpace),
      child: Row(
        children: [
          IconButton(
              iconSize: iconSize,
              icon: const Icon(Icons.arrow_back_ios, color: tertiaryColor, size: 20),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          const SizedBox(width: maxSpace),
          Row(
            children: [
              SizedBox(
                width: deviceWidth(context) * 0.75,
                child: Text(
                  text != null ? text! : "She Wo",
                  softWrap: false,
                  style: TextStyle(
                      fontFamily: leadingFont, fontSize: (text?.length ?? 6) >= 20 ? 20 : 25, color: tertiaryColor, overflow: TextOverflow.fade),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
