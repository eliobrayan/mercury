import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  int currentPage = 0;
  jumpToPage(int index) {
    currentPage = index;
    notifyListeners();
  }
}
