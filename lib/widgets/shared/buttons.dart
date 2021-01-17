import 'package:flutter/material.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';

Widget roundedButton(
    {String text,
    void action(),
    Color color,
    Color textColor,
    bool border = false,
    Color borderColor,
    double borderWidth = 1,
    EdgeInsetsGeometry padding,
    double radius = 20}) {
  return MaterialButton(
    onPressed: () {
      action();
    },
    padding: padding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: border
          ? BorderSide(
              color: borderColor,
              width: borderWidth,
            )
          : BorderSide.none,
    ),
    color: color,
    child: Text(
      text,
      style: TextStyle(color: textColor, fontSize: MySizes.button),
    ),
  );
}

Widget formButton(
    {String text,
    void action(),
    Color fillColor,
    Color borderColor,
    bool isOutlined = false,
    double borderWidth = 1,
    EdgeInsetsGeometry padding,
    EdgeInsetsGeometry margin,
    double radius = 5}) {
  return Container(
    margin: margin,
    child: MaterialButton(
      onPressed: () {
        action();
      },
      child: Text(
        text,
        style: TextStyle(color: isOutlined ? borderColor : MyColors.primary),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: isOutlined
            ? BorderSide(
                color: borderColor,
                width: borderWidth,
              )
            : BorderSide.none,
      ),
      color: isOutlined ? MyColors.primary : fillColor,
      padding: padding,
    ),
  );
}
