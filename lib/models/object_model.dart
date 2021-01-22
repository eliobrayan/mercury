List<T> objectsFromJson<T>(List<dynamic> list, object) {
  List<T> listObjects = List<T>();

  list.forEach((element) {
    listObjects.add(object.fromJson(element));
  });
  return listObjects;
}

List<T> objectsFromMap<T>(List<dynamic> list, object) {
  List<T> listObjects = List<T>();

  list.forEach((element) {
    listObjects.add(object.fromMap(element));
  });
  return listObjects;
}
