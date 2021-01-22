import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mercury/core/Exceptions/exceptions.dart';
import 'package:mercury/core/providers/crud_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/models/provider_model.dart';

class ProviderProvider extends ChangeNotifier {
  CRUDProvider provider = CRUDProvider();
  List<ProviderModel> providers;
  List<ProviderModel> dirtyproviders;
  ProviderStates state = ProviderStates.idle;
  String errorMessage;
  getProviders() {
    try {
      Stream<QuerySnapshot> stream = provider.readEntities("providers");
      print(stream);
      stream.listen((event) {
        providers = providersFromMap(event.docs);
        dirtyproviders = providers;
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
    dirtyproviders = providers;
    dirtyproviders = dirtyproviders
        .where((i) => i.name.toLowerCase().contains(key.toLowerCase().trim()))
        .toList();
    state = ProviderStates.done;
    notifyListeners();
  }
}
