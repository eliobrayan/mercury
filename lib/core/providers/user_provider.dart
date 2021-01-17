import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mercury/core/Exceptions/exceptions.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/core/repositories/user_repository.dart';
import 'package:mercury/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel user;
  UserRepository repository = UserRepository();
  String errorMsg;
  ProviderStates state = ProviderStates.idle;
  createUser(
      String email, String name, String lastName, String password) async {
    try {
      UserModel userTemp = UserModel(
          email: email, name: name, password: password, lastName: lastName);
      await repository.createUserWithEmailAndPassword(userTemp);
      user = await repository.getCurrentUserFromFirestore();
      state = ProviderStates.done;
      notifyListeners();
    } on LoginException catch (e) {
      errorMsg = e.message;

      state = ProviderStates.error;
      notifyListeners();
    }
  }

  login(String email, String password) async {
    try {
      await repository.loginWithEmailAndPassword(email, password);
      user = await repository.getCurrentUserFromFirestore();
      state = ProviderStates.done;
      notifyListeners();
    } catch (e) {
      if (e is LoginException) {
        errorMsg = e.message;
      } else if (e is FirebaseException) {
        errorMsg = e.message;
      } else {
        errorMsg = "Ocurrió un error";
      }
      state = ProviderStates.error;
      notifyListeners();
    }
  }

  updateUser() {
    try {
      repository.updateInFirestore(user).then((value) {
        user = value;
        state = ProviderStates.done;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      errorMsg = e.message;
      state = ProviderStates.error;
      notifyListeners();
    }
  }

  deleteUser() {
    try {
      repository.deleteUserFromFirestore().then((value) {
        state = ProviderStates.done;
        notifyListeners();
      });
    } catch (e) {
      if (e is FirebaseException) {
        errorMsg = e.message;
      } else {
        errorMsg = "Ocurrió un error";
      }
      state = ProviderStates.error;
      notifyListeners();
    }
  }

  getCurrentUser() async {
    try {
      user = await repository.getCurrentUserFromFirestore();
      state = ProviderStates.done;
      notifyListeners();
    } catch (e) {
      if (e is LoginException) {
        errorMsg = e.message;
      } else if (e is FirebaseException) {
        errorMsg = e.message;
      } else {
        errorMsg = "Ocurrió un error";
      }
      state = ProviderStates.error;
      notifyListeners();
    }
  }
}
