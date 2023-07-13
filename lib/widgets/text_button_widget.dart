import 'package:she_wo/settings/consts.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final String? buttonText;
  final VoidCallback? onPressed;
  final Widget? icon;
  const TextButtonWidget({Key? key, this.buttonText, this.onPressed, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: maxSpace, left: maxSpace, bottom: minSpace),
      child: Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(maxSpace)), color: tertiaryColor),
        child: TextButton(
          style: const ButtonStyle(),
          onPressed: onPressed,
          child: icon == null
              ? Text(buttonText!, style: const TextStyle(color: darkWhite, fontSize: 15, fontFamily: contentFont))
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(buttonText!, style: const TextStyle(color: white, fontSize: 15, fontFamily: contentFont)),
                  SizedBox(width: deviceWidth(context) * 0.01),
                  icon!
                ]),
        ),
      ),
    );
  }
}
