import 'package:flutter/material.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';

Widget loginFormInput({
  TextInputType inputType,
  TextEditingController controller,
  String hintText,
  Widget icon,
  AutovalidateMode validateMode,
  String validatorAction(String value),
  bool obscureText = false,
  bool isPassword = false,
  void hidePassword(),
}) {
  return TextFormField(
    style: TextStyle(
        fontSize: MySizes.body2,
        fontStyle: FontStyle.italic,
        color: MyColors.light),
    keyboardType: inputType,
    decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.secondary),
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: hintText,
        prefixIcon: icon,
        suffixIcon: isPassword
            ? MaterialButton(
                onPressed: () {
                  hidePassword();
                },
                child: obscureText
                    ? Icon(
                        Icons.visibility_off_sharp,
                        color: MyColors.secondary,
                      )
                    : Icon(
                        Icons.visibility_sharp,
                        color: MyColors.accent,
                      ),
              )
            : null),
    autovalidateMode: validateMode,
    autocorrect: false,
    controller: controller,
    obscureText: obscureText,
    validator: (v) {
      return validatorAction(v);
    },
  );
}

Widget formInput({
  TextInputType inputType,
  TextEditingController controller,
  String hintText,
  Widget icon,
  bool readOnly = false,
  AutovalidateMode validateMode,
  String validatorAction(String value),
}) {
  return TextFormField(
    style: TextStyle(
        fontSize: MySizes.body2,
        fontStyle: FontStyle.italic,
        color: MyColors.light),
    keyboardType: inputType,
    readOnly: readOnly,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: MyColors.secondary),
        borderRadius: BorderRadius.circular(30),
      ),
      labelText: hintText,
      prefixIcon: icon,
    ),
    autovalidateMode: validateMode,
    autocorrect: false,
    controller: controller,
    validator: (v) {
      return validatorAction(v);
    },
  );
}

Widget searchInput({
  TextEditingController controller,
  String hintText,
  void onChanged(String value),
}) {
  return TextFormField(
    style: TextStyle(
        fontSize: MySizes.body2,
        fontStyle: FontStyle.italic,
        color: MyColors.light),
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: MyColors.secondary),
        borderRadius: BorderRadius.circular(30),
      ),
      labelText: hintText,
      prefixIcon: Icon(
        Icons.search,
        color: MyColors.accent,
      ),
    ),
    onChanged: (value) {
      onChanged(value);
    },
    autocorrect: false,
    controller: controller,
  );
}
