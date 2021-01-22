import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mercury/core/Exceptions/exceptions.dart';
import 'package:mercury/core/providers/crud_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/models/ballooms_model.dart';
import 'package:mercury/models/customer_model.dart';

class BalloomsProvider extends ChangeNotifier {
  CRUDProvider provider = CRUDProvider();
  List<BalloomsModel> ballooms;
  List<BalloomsModel> dirtyBallooms;
  ProviderStates state = ProviderStates.idle;
  String errorMessage;
  getBallooms() {
    try {
      Stream<QuerySnapshot> stream = provider.readEntities("ballooms");
      print(stream);
      stream.listen((event) {
        ballooms = balloomsFromMap(event.docs);
        dirtyBallooms = ballooms;
        state = ProviderStates.done;
        notifyListeners();
      });
    } on CRUDException catch (e) {
      errorMessage = e.message;
      state = ProviderStates.error;
      notifyListeners();
    }
  }

  searchCustomer(String key) {
    dirtyBallooms = ballooms;
    dirtyBallooms = dirtyBallooms
        .where((i) => i.name.toLowerCase().contains(key.toLowerCase().trim()))
        .toList();
    state = ProviderStates.done;
    notifyListeners();
  }
}
