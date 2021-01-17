import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mercury/core/Exceptions/exceptions.dart';
import 'package:mercury/core/providers/crud_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/models/customer_model.dart';

class CustomersProvider extends ChangeNotifier {
  CRUDProvider provider = CRUDProvider();
  List<CustomerModel> customers;
  List<CustomerModel> dirtyCustomers;
  ProviderStates state = ProviderStates.idle;
  String errorMessage;
  getCustomers() {
    try {
      Stream<QuerySnapshot> stream = provider.readEntities("customers");
      print(stream);
      stream.listen((event) {
        customers = customersFromMap(event.docs);
        dirtyCustomers = customers;
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
    dirtyCustomers = customers;
    dirtyCustomers = dirtyCustomers
        .where((i) => i.name.toLowerCase().contains(key.toLowerCase().trim()))
        .toList();
    state = ProviderStates.done;
    notifyListeners();
  }
}
