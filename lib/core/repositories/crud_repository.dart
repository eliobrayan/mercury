import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mercury/core/Exceptions/exceptions.dart';
import 'package:mercury/core/repositories/user_repository.dart';

class CRUDRepository {
  createEntity(dynamic entity, String reference) async {
    try {
      var docReference = await FirebaseFirestore.instance
          .collection(reference)
          .add(entity.toJson());
      await FirebaseFirestore.instance
          .collection(reference)
          .doc(docReference.id)
          .update({"id": docReference.id});
    } catch (e) {
      String response;
      if (e is PlatformException) {
        if (e.code == "already-exists") {
          response = "el registro ya existe";
        } else if (e.code == "cancelled") {
          response = "el registro fue cancelado";
        } else if (e.code == "data-loss") {
          response = "No se pudo enviar al servidor correctamente";
        } else if (e.code == "invalid-argument") {
          response = "argumentos inválidos";
        } else if (e.code == "not-found") {
          response = "No se encontró el documento de destino";
        } else {
          response = "Error con el servidor Firestore";
        }
      } else {
        response = "Error con el servidor";
      }
      throw FirestoreException(response);
    }
  }

  updateEntity(dynamic entity, String reference, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection(reference)
          .doc(docId)
          .update(entity.toJson());
    } catch (e) {
      String response;
      if (e is PlatformException) {
        if (e.code == "already-exists") {
          response = "el registro ya existe";
        } else if (e.code == "cancelled") {
          response = "el registro fue cancelado";
        } else if (e.code == "data-loss") {
          response = "No se pudo enviar al servidor correctamente";
        } else if (e.code == "invalid-argument") {
          response = "argumentos inválidos";
        } else if (e.code == "not-found") {
          response = "No se encontró el documento de destino";
        } else {
          response = "Error con el servidor Firestore";
        }
      } else {
        response = "Error con el servidor";
      }
      throw FirestoreException(response);
    }
  }

  deleteEntity(dynamic entity, String reference, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection(reference)
          .doc(docId)
          .delete();
    } catch (e) {
      String response;
      if (e is PlatformException) {
        if (e.code == "already-exists") {
          response = "el registro ya existe";
        } else if (e.code == "cancelled") {
          response = "el registro fue cancelado";
        } else if (e.code == "data-loss") {
          response = "No se pudo enviar al servidor correctamente";
        } else if (e.code == "invalid-argument") {
          response = "argumentos inválidos";
        } else if (e.code == "not-found") {
          response = "No se encontró el documento de destino";
        } else {
          response = "Error con el servidor Firestore";
        }
      } else {
        response = "Error con el servidor";
      }
      throw FirestoreException(response);
    }
  }

  Future<DocumentSnapshot> readEntity(String reference, String docId) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection(reference)
          .doc(docId)
          .get();
      return data;
    } catch (e) {
      String response;
      if (e is PlatformException) {
        if (e.code == "already-exists") {
          response = "el registro ya existe";
        } else if (e.code == "cancelled") {
          response = "el registro fue cancelado";
        } else if (e.code == "data-loss") {
          response = "No se pudo enviar al servidor correctamente";
        } else if (e.code == "invalid-argument") {
          response = "argumentos inválidos";
        } else if (e.code == "not-found") {
          response = "No se encontró el documento de destino";
        } else {
          response = "Error con el servidor Firestore";
        }
      } else {
        response = "Error con el servidor";
      }
      throw FirestoreException(response);
    }
  }

  Stream<QuerySnapshot> readEntities(String reference) {
    try {
      return FirebaseFirestore.instance.collection(reference).snapshots();
    } catch (e) {
      String response;
      if (e is PlatformException) {
        if (e.code == "already-exists") {
          response = "el registro ya existe";
        } else if (e.code == "cancelled") {
          response = "el registro fue cancelado";
        } else if (e.code == "data-loss") {
          response = "No se pudo enviar al servidor correctamente";
        } else if (e.code == "invalid-argument") {
          response = "argumentos inválidos";
        } else if (e.code == "not-found") {
          response = "No se encontró el documento de destino";
        } else {
          response = "Error con el servidor Firestore";
        }
      } else {
        response = "Error con el servidor";
      }
      throw FirestoreException(response);
    }
  }
}
