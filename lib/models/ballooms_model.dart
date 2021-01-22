import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

List<BalloomsModel> balloomsFromJson(List<dynamic> list) {
  List<BalloomsModel> listUsers = List<BalloomsModel>();
  list.forEach((element) {
    listUsers.add(BalloomsModel.fromJson(element));
  });
  return listUsers;
}

List<BalloomsModel> balloomsFromMap(List<dynamic> list) {
  List<BalloomsModel> listUsers = List<BalloomsModel>();
  list.forEach((element) {
    listUsers.add(BalloomsModel.fromMap(element));
  });
  return listUsers;
}

/*
List<CategoryModel> categoryFromJson(String str) => List<CategoryModel>.from(
    json.decode(str).map((x) => CategoryModel.fromJson(x)));
*/
String usersToJson(List<BalloomsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BalloomsModel {
  String type;
  String id;
  String name;
  double weight;
  double priceBuy;
  double priceSale;
  BalloomsModel({
    @required this.type,
    @required this.weight,
    @required this.priceBuy,
    @required this.priceSale,
    @required this.name,
    this.id,
  });
  factory BalloomsModel.fromJson(Map<String, dynamic> data) {
    return BalloomsModel(
        type: data["type"] == null ? "none" : data["type"],
        id: data["id"] == null ? "none" : data["id"],
        weight: data["weight"] == null ? 0.0 : data["weight"].toDouble(),
        priceBuy:
            data["price_buy"] == null ? 0.0 : data["price_buy"].toDouble(),
        priceSale:
            data["price_sale"] == null ? 0.0 : data["price_sale"].toDouble(),
        name: data["name"] == null ? "none" : data["name"]);
  }
  factory BalloomsModel.fromMap(QueryDocumentSnapshot data) {
    return BalloomsModel(
        type: data["type"] == null ? "none" : data["type"],
        id: data["id"] == null ? "none" : data["id"],
        weight: data["weight"] == null ? 0.0 : data["weight"].toDouble(),
        priceBuy:
            data["price_buy"] == null ? 0.0 : data["price_buy"].toDouble(),
        priceSale:
            data["price_sale"] == null ? 0.0 : data["price_sale"].toDouble(),
        name: data["name"] == null ? "none" : data["name"]);
  }
  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "weight": weight == null ? null : weight,
        "price_buy": priceBuy == null ? null : priceBuy,
        "price_sale": priceSale == null ? null : priceSale,
        "name": name == null ? null : name,
        "id": id == null ? null : id,
      };
}
