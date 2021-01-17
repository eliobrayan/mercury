import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

List<CustomerModel> customersFromJson(List<dynamic> list) {
  List<CustomerModel> listUsers = List<CustomerModel>();
  list.forEach((element) {
    listUsers.add(CustomerModel.fromJson(element));
  });
  return listUsers;
}

List<CustomerModel> customersFromMap(List<dynamic> list) {
  List<CustomerModel> listUsers = List<CustomerModel>();
  list.forEach((element) {
    listUsers.add(CustomerModel.fromMap(element));
  });
  return listUsers;
}

/*
List<CategoryModel> categoryFromJson(String str) => List<CategoryModel>.from(
    json.decode(str).map((x) => CategoryModel.fromJson(x)));
*/
String customersToJson(List<CustomerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerModel {
  String name;
  String lastName;
  String phone;
  String address;
  String reference;
  DateTime createDate;
  String type;
  String id;
  CustomerModel(
      {@required this.name,
      @required this.address,
      this.reference,
      this.lastName,
      this.type,
      this.id,
      this.createDate,
      this.phone});
  factory CustomerModel.fromJson(Map<String, dynamic> data) {
    return CustomerModel(
        address: data["address"] == null ? "none" : data["address"],
        name: data["name"] == null ? "none" : data["name"],
        lastName: data["last_name"] == null ? "none" : data["last_name"],
        id: data["id"] == null ? "none" : data["id"],
        type: data["type"] == null ? "none" : data["type"],
        phone: data["phone"] == null ? "none" : data["phone"],
        createDate:
            data["create_date"] == null ? null : data["create_date"].toDate(),
        reference: data["reference"] == null ? "none" : data["reference"]);
  }
  factory CustomerModel.fromMap(QueryDocumentSnapshot data) {
    return CustomerModel(
        address: data["address"] == null ? "none" : data["address"],
        name: data["name"] == null ? "none" : data["name"],
        lastName: data["last_name"] == null ? "none" : data["last_name"],
        id: data["id"] == null ? "none" : data["id"],
        type: data["type"] == null ? "none" : data["type"],
        phone: data["phone"] == null ? "none" : data["phone"],
        createDate:
            data["create_date"] == null ? null : data["create_date"].toDate(),
        reference: data["reference"] == null ? "none" : data["reference"]);
  }
  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "last_name": name == null ? null : lastName,
        "phone": phone == null ? null : phone,
        "type": type == null ? null : type,
        "reference": reference == null ? null : reference,
        "address": address == null ? null : address,
        "create_date": createDate == null ? null : createDate,
      };
  @override
  String toString() {
    return "id:$id, name:$name, lastName:$lastName,phone:$phone, type:$type, reference:$reference, address:$address, create_date:$createDate";
  }
}
