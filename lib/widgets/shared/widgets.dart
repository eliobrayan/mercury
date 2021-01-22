import 'package:flutter/material.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';

Widget headerForms({String imageUrl}) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Image.asset(imageUrl),
  );
}

Widget cardInformation({
  Color backgroundColor,
  String title,
  String subtitle,
  String info,
  Widget icon,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    color: backgroundColor,
    shadowColor: backgroundColor.withAlpha(50),
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      color: MyColors.white, fontSize: MySizes.subTitle),
                ),
              ),
              icon
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    info,
                    style: TextStyle(
                        color: MyColors.primaryLight, fontSize: MySizes.title4),
                  )
                ],
              ),
            ),
          ),
          Text(
            subtitle,
            style:
                TextStyle(color: MyColors.white, fontSize: MySizes.subtitle2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
