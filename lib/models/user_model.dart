import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

List<UserModel> usersFromJson(List<dynamic> list) {
  List<UserModel> listUsers = List<UserModel>();
  list.forEach((element) {
    listUsers.add(UserModel.fromJson(element));
  });
  return listUsers;
}

List<UserModel> usersFromMap(List<dynamic> list) {
  List<UserModel> listUsers = List<UserModel>();
  list.forEach((element) {
    listUsers.add(UserModel.fromMap(element));
  });
  return listUsers;
}

/*
List<CategoryModel> categoryFromJson(String str) => List<CategoryModel>.from(
    json.decode(str).map((x) => CategoryModel.fromJson(x)));
*/
String usersToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  String name;
  String lastName;
  String email;
  String password;
  String uid;
  UserModel(
      {@required this.email,
      @required this.name,
      this.uid,
      this.password,
      this.lastName});
  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
        email: data["email"] == null ? "none" : data["email"],
        name: data["name"] == null ? "none" : data["name"],
        lastName: data["last_name"] == null ? "none" : data["last_name"],
        uid: data["uid"] == null ? "none" : data["uid"]);
  }
  factory UserModel.fromMap(QueryDocumentSnapshot data) {
    return UserModel(
        email: data["email"] == null ? "none" : data["email"],
        name: data["name"] == null ? "none" : data["name"],
        lastName: data["last_name"] == null ? "none" : data["last_name"],
        uid: data["uid"] == null ? "none" : data["uid"]);
  }
  Map<String, dynamic> toJson() => {
        "uid": uid == null ? null : uid,
        "name": name == null ? null : name,
        "last_name": name == null ? null : lastName,
        "email": email == null ? null : email,
      };
}
