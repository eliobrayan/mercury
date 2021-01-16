import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:mercury/core/Exceptions/exceptions.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/core/repositories/crud_repository.dart';

class CRUDProvider extends ChangeNotifier {
  CRUDRepository repository = CRUDRepository();
  ProviderStates state;
  String msgError;
  Object entity;
  createEntity(dynamic entity, String reference) async {
    try {
      await repository.createEntity(entity, reference);
      state = ProviderStates.done;
      notifyListeners();
    } on FirestoreException catch (e) {
      msgError = e.message;
      state = ProviderStates.error;
      notifyListeners();
    }
  }

  updateEntity(dynamic entity, String reference, String docId) async {
    try {
      await repository.updateEntity(entity, reference, docId);
      state = ProviderStates.done;
      notifyListeners();
    } on FirestoreException catch (e) {
      msgError = e.message;
      state = ProviderStates.error;
      notifyListeners();
    }
  }

  deleteEntity(String reference, String docId) async {
    try {
      await repository.deleteEntity(entity, reference, docId);
      state = ProviderStates.done;
      notifyListeners();
    } on FirestoreException catch (e) {
      msgError = e.message;
      state = ProviderStates.error;
      notifyListeners();
    }
  }

  readEntity(String reference, String docId) async {
    try {
      entity = await repository.readEntity(reference, docId);
      state = ProviderStates.done;
      notifyListeners();
    } on FirestoreException catch (e) {
      msgError = e.message;
      state = ProviderStates.error;
      notifyListeners();
    }
  }

  Stream<QuerySnapshot> readEntities(String reference) {
    try {
      notifyListeners();
      return repository.readEntities(reference);
    } on FirestoreException catch (e) {
      throw CRUDException(e.message);
    }
  }
}
