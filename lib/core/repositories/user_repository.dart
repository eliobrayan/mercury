import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mercury/core/Exceptions/exceptions.dart';
import 'package:mercury/models/user_model.dart';

class UserRepository {
  //create user
  Future<void> createUserWithEmailAndPassword(UserModel user) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password);
      user.uid = credential.user.uid;
      await createUserInFirestore(user);
    } catch (e) {
      String response;
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          response = "La contraseña es muy débil";
        } else if (e.code == 'email-already-in-use') {
          response = "El correo ingresado ya existe";
        } else if (e.code == 'invalid-email') {
          response = "El correo ingresado es inválido";
        } else {
          response = "Ocurrió un error al registrar";
        }
      } else if (e is FirestoreException) {
        response = e.message;
      } else if (e is PlatformException) {
        if (e.code == 'weak-password') {
          response = "La contraseña es muy débil";
        } else if (e.code == 'email-already-in-use') {
          response = "El correo ingresado ya existe";
        } else if (e.code == 'invalid-email') {
          response = "El correo ingresado es inválido";
        } else {
          response = "Ocurrió un error al registrar";
        }
      } else {
        response = "Error con el servidor";
      }

      print("Login Exception: $response");
      throw LoginException(response);
    }
  }

  //logueo user
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      print("Logueando usuario en auth");
      print(email);
      print(password);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      String response;
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          response = "El email no esta registrado";
        } else if (e.code == 'wrong-password') {
          response = "Email o password incorrectos";
        }
      } else if (e is PlatformException) {
        if (e.code == 'user-not-found') {
          response = "El email no esta registrado";
        } else if (e.code == 'wrong-password') {
          response = "Email o password incorrectos";
        }
      } else {
        response = "Error con el servidor";
      }
      print("Login Exception: $response");
      throw LoginException(response);
    }
  }

  //registrar en firestore
  Future<void> createUserInFirestore(UserModel user) async {
    try {
      print("Creando Usuario en firestore");
      print(user.toString());
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());
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

  Future<void> changePassword(String newPassword) async {
    print("changing password");
    try {
      User userAuth = FirebaseAuth.instance.currentUser;
      userAuth.updatePassword(newPassword);
    } catch (e) {
      String response;
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          response = "La contraseña es muy débil";
        } else if (e.code == 'email-already-in-use') {
          response = "El correo ingresado ya existe";
        } else if (e.code == 'invalid-email') {
          response = "El correo ingresado es inválido";
        } else {
          response = "Ocurrió un error al registrar";
        }
      } else if (e is FirestoreException) {
        response = e.message;
      } else if (e is PlatformException) {
        if (e.code == 'weak-password') {
          response = "La contraseña es muy débil";
        } else if (e.code == 'email-already-in-use') {
          response = "El correo ingresado ya existe";
        } else if (e.code == 'invalid-email') {
          response = "El correo ingresado es inválido";
        } else {
          response = "Ocurrió un error al registrar";
        }
      } else {
        response = "Error con el servidor";
      }

      print("Login Exception: $response");
      throw LoginException(response);
    }
  }

  //actualizar en firestore
  Future<UserModel> updateInFirestore(UserModel user) async {
    try {
      print("Actualizando Usuario en firestore");

      User userAuth = FirebaseAuth.instance.currentUser;
      String id = userAuth.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update(user.toJson());
      return user;
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

  //eliminar de firestore
  Future<void> deleteUserFromFirestore() async {
    print("Eliminando usuario en firestore");
    User user = FirebaseAuth.instance.currentUser;

    String id = user.uid;
    try {
      await FirebaseFirestore.instance.collection("users").doc(id).delete();
      await FirebaseAuth.instance.currentUser.delete();
    } on PlatformException catch (e) {
      print(e.toString());
      throw FirestoreException("Ocurrió un error al eliminar usuario");
    }
  }

  Future<User> getLoginStatus() async {
    print("Obteniendo estado de sesión");
    User user = FirebaseAuth.instance.currentUser;
    return user ?? null;
  }

  //obtener de firestore
  Future<UserModel> getCurrentUserFromFirestore() async {
    print("Obteniendo usuario en firestore");
    User user = FirebaseAuth.instance.currentUser;
    String id = user.uid;
    UserModel userModel;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .get()
          .then((value) {
        userModel = UserModel.fromJson(value.data());
        print("auth usuario recuperado:${userModel.toString()}");
        userModel.uid = id;
      });

      return userModel;
    } on PlatformException catch (e) {
      print(e.toString());
      throw FirestoreException("Ocurrió un error al recuperar usuario");
    }
  }
}
