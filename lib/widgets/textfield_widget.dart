import 'package:she_wo/settings/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final double? height;

  const TextFieldWidget(
      {Key? key,
      this.hintText,
      this.textEditingController,
      this.keyboardType,
      this.obscureText,
      this.inputFormatters,
      this.validator,
      this.onTap,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: minSpace, right: maxSpace, left: maxSpace),
      child: SizedBox(
        height: deviceHeight(context) * 0.07,
        width: deviceWidth(context),
        child: TextFormField(
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: onTap,
          inputFormatters: inputFormatters,
          obscuringCharacter: "*",
          controller: textEditingController,
          keyboardType: keyboardType,
          obscureText: obscureText!,
          cursorColor: tertiaryColor,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Colors.black, width: 0.0),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.all(height ?? maxSpace),
            filled: true,
            fillColor: secondaryColor,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 17, fontFamily: contentFont),
            // focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: secondaryColor), borderRadius: BorderRadius.circular(maxSpace)),
          ),
        ),
      ),
    );
  }
}
