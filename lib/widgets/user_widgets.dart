import 'package:flutter/material.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/styles.dart';

Future<bool> showUpdatePasswordDialog(
    {BuildContext context,
    String title,
    String content,
    String textCancel = "Cancelar",
    String textOk = "Actualizar"}) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Actualizar Password",
            style: textStyleTitle(MyColors.accent),
          ),
          content: Column(
            children: [],
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(textCancel),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(textOk),
            ),
          ],
        );
      });
}
