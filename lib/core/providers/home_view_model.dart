import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mercury/ui/views/customers/customers_page.dart';
import 'package:mercury/ui/views/home_page.dart';
import 'package:mercury/ui/views/providers/providers_page.dart';
import 'package:mercury/ui/views/sales/sales_page.dart';
import 'package:mercury/ui/views/user/user_profile_page.dart';

class HomeViewModel extends ChangeNotifier {
  int currentPage = 0;
  String titleCurrentPage = "home";
  PageController pageController = PageController(initialPage: 0);
  List<String> titlesPages = [
    "Home",
    "Mi perfil",
    "Mis clientes",
    "Mis proveedores",
    "Mis ventas"
  ];
  List<Widget> listPages = [
    BodyHome(),
    UserProfilePage(),
    CustomersPage(),
    ProvidersPage(),
    SalesPage(),
  ];
  jumpToPage(int index) {
    currentPage = index;
    titleCurrentPage = titlesPages[currentPage];
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    notifyListeners();
  }
}
