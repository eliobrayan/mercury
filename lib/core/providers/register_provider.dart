import 'package:flutter/cupertino.dart';
import 'package:mercury/core/Exceptions/exceptions.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/core/repositories/user_repository.dart';
import 'package:mercury/models/user_model.dart';

class RegisterProvider extends ChangeNotifier {
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
}
