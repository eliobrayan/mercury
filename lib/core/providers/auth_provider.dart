import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/core/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  User userFirebase;
  AuthRepository repository = AuthRepository();
  String errorMsg;
  ProviderStates state = ProviderStates.idle;

  getLoginStatus() {
    try {
      repository.getLoginStatus().then((value) {
        userFirebase = value;
        state = ProviderStates.done;
        print("datos de sesión obtenidos");
        notifyListeners();
      });
    } on AuthException catch (e) {
      errorMsg = e.message;
      state = ProviderStates.error;

      notifyListeners();
    }
  }

  logout() {
    try {
      repository.logout().then((value) {
        userFirebase = null;

        print("Sesión cerrada");
        notifyListeners();
      });
    } on AuthException catch (e) {
      errorMsg = e.message;
      state = ProviderStates.error;

      notifyListeners();
    }
  }
}
