class FirestoreException implements Exception {
  final String message;

  FirestoreException(this.message);
}

class LoginException implements Exception {
  final String message;

  LoginException(this.message);
}

class CRUDException implements Exception {
  final String message;

  CRUDException(this.message);
}
