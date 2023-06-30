import 'package:she_wo/settings/consts.dart';
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final Widget? child;
  const ListTileWidget({Key? key, this.onTap, this.text, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: maxSpace, left: maxSpace, top: minSpace),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(maxSpace),
            child: Container(
              height: deviceHeight(context) * 0.06,
              color: tertiaryColor,
              child: Padding(
                padding: const EdgeInsets.only(right: maxSpace, left: maxSpace),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: Text(text!, style: const TextStyle(fontSize: 18, color: white))),
                    child!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
