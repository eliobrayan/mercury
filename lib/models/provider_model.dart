import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

List<ProviderModel> providersFromJson(List<dynamic> list) {
  List<ProviderModel> listUsers = List<ProviderModel>();
  list.forEach((element) {
    listUsers.add(ProviderModel.fromJsonFactory(element));
  });
  return listUsers;
}

List<ProviderModel> providersFromMap(List<dynamic> list) {
  List<ProviderModel> listUsers = List<ProviderModel>();
  list.forEach((element) {
    listUsers.add(ProviderModel.fromMapFactory(element));
  });
  return listUsers;
}

/*
List<CategoryModel> categoryFromJson(String str) => List<CategoryModel>.from(
    json.decode(str).map((x) => CategoryModel.fromJson(x)));
*/
String providersToJson(List<ProviderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProviderModel {
  String name;
  String lastName;
  String phone;

  String reference;

  String id;
  ProviderModel(
      {@required this.name,
      this.reference,
      this.lastName,
      this.id,
      this.phone});
  factory ProviderModel.fromJsonFactory(Map<String, dynamic> data) {
    return ProviderModel(
        name: data["name"] == null ? "none" : data["name"],
        lastName: data["last_name"] == null ? "none" : data["last_name"],
        id: data["id"] == null ? "none" : data["id"],
        phone: data["phone"] == null ? "none" : data["phone"],
        reference: data["reference"] == null ? "none" : data["reference"]);
  }
  fromJson(Map<String, dynamic> data) {
    return ProviderModel.fromJsonFactory(data);
  }

  fromMap(QueryDocumentSnapshot data) {
    return ProviderModel.fromMapFactory(data);
  }

  factory ProviderModel.fromMapFactory(QueryDocumentSnapshot data) {
    return ProviderModel(
        name: data["name"] == null ? "none" : data["name"],
        lastName: data["last_name"] == null ? "none" : data["last_name"],
        id: data["id"] == null ? "none" : data["id"],
        phone: data["phone"] == null ? "none" : data["phone"],
        reference: data["reference"] == null ? "none" : data["reference"]);
  }
  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "last_name": name == null ? null : lastName,
        "phone": phone == null ? null : phone,
        "reference": reference == null ? null : reference,
      };
  @override
  String toString() {
    return "Provider id:$id, name:$name, lastName:$lastName,phone:$phone, reference:$reference";
  }
}
