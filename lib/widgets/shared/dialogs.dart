import 'package:flutter/material.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/styles.dart';

class ShowProgressDialog {
  String content;
  BuildContext contextInt;
  ShowProgressDialog();
  showLoadingDialog(BuildContext context, String content) {
    contextInt = context;
    this.content = content;
    showDialog(
        context: contextInt,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Expanded(child: Text(content)),
              ],
            ),
          );
        });
  }

  close() {
    Navigator.of(contextInt).pop();
  }
}

Future<bool> showQuestionDialog(
    {BuildContext context,
    String title,
    String content,
    String textCancel = "Cancelar",
    String textOk = "Aceptar"}) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: textStyleTitle(MyColors.accent),
          ),
          content: Text(content),
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

createSnackBar(BuildContext context, String message) {
  final snackBar = new SnackBar(
    content: new Text(
      message,
      style: TextStyle(color: MyColors.light),
    ),
    backgroundColor: MyColors.accent,
  );

  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
  Scaffold.of(context).showSnackBar(snackBar);
}
