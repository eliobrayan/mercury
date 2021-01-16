import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

class AuthRepository {
  //cerrar sesión
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      String response;
      if (e is FirebaseException) {
        response = e.message;
      } else if (e is PlatformException) {
        response = e.message;
      } else {
        response = "Ocurrió un error al obtener el estado de sesión";
      }
      throw AuthException(response);
    }
  }

  Future<User> getLoginStatus() async {
    try {
      print("Obteniendo estado de sesión");
      User user = FirebaseAuth.instance.currentUser;
      return user ?? null;
    } catch (e) {
      String response;
      if (e is FirebaseException) {
        response = e.message;
      } else if (e is PlatformException) {
        response = e.message;
      } else {
        response = "Ocurrió un error al obtener el estado de sesión";
      }
      throw AuthException(response);
    }
  }
}

class AuthException {
  final String message;

  AuthException(this.message);
}
