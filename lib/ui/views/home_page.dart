import 'package:flutter/material.dart';
import 'package:mercury/core/providers/home_view_model.dart';
import 'package:mercury/ui/views/customers/customers_page.dart';
import 'package:mercury/ui/views/providers/providers_page.dart';

import 'package:mercury/ui/views/sales/sales_page.dart';
import 'package:mercury/ui/views/user/user_profile_page.dart';
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
    UserProfilePage(),
    CustomersPage(),
    ProvidersPage(),
    SalesPage(),
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
        title: Consumer<HomeViewModel>(
          builder: (BuildContext context, value, Widget child) {
            return Text(value.titleCurrentPage);
          },
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(),
      body: MyPageView(),
      drawer: MyDrawer(),
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
