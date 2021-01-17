import 'package:flutter/material.dart';
import 'package:mercury/core/providers/customers_provider.dart';
import 'package:mercury/ui/views/customers/customers_page.dart';
import 'package:mercury/ui/views/providers_page.dart';
import 'package:mercury/ui/views/sales_page.dart';
import 'package:mercury/widgets/home_widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController;

  List<Widget> listPages = [
    BodyHome(),
    ProvidersPage(),
    CustomersPage(),
    SalesPage(),
    SalesPage(),
    SalesPage()
  ];
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      bottomNavigationBar: MyBottomNavBar(
        pageController: pageController,
      ),
      body: MyPageView(
        pageController: pageController,
        indexLimitScroll: 2,
        listPages: listPages,
      ),
      drawer: MyDrawer(
        pageController: pageController,
      ),
    );
  }
}

class BodyHome extends StatelessWidget {
  const BodyHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("home"),
        ],
      ),
    );
  }
}
