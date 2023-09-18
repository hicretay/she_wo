import 'dart:io';

import 'package:she_wo/settings/consts.dart';
import 'package:flutter/material.dart';

class ExitAlertDialog extends StatelessWidget {
  const ExitAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Uygulamadan çıkılsın mı?"),
      actions: <Widget>[
        MaterialButton(
          color: tertiaryColor,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            "Hayır",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.normal, color: white),
          ),
        ),
        MaterialButton(
          color: tertiaryColor,
          onPressed: () {
            exit(0);
          },
          child: Text("Evet", style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.normal, color: white)),
        ),
      ],
    );
  }
}
