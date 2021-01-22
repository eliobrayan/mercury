import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:mercury/core/providers/auth_provider.dart';
import 'package:mercury/core/providers/home_view_model.dart';
import 'package:mercury/core/providers/user_provider.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';
import 'package:mercury/misc/styles.dart';
import 'package:mercury/widgets/shared/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:mercury/misc/library/utils.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: MyColors.primary),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logoTemp.png"),
                  SizedBox(
                    height: 20,
                  ),
                  Consumer<UserProvider>(
                    builder: (context, value, _) {
                      if (value.user != null) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${value.user.name.capitalize()}",
                                  style: textStyleTitle(MyColors.secondary),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${value.user.lastName.capitalize()}",
                                  style: textStyleTitle(MyColors.secondary),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${value.user.email}",
                                  style: textStyleSubTitle(MyColors.grayLight),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Provider.of<UserProvider>(context, listen: false)
                            .getCurrentUser();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Nombres",
                                style: TextStyle(
                                    color: MyColors.accent,
                                    fontSize: MySizes.subTitle),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email",
                                style: TextStyle(
                                    color: MyColors.grayLight,
                                    fontSize: MySizes.subtitle2),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(color: MyColors.primary),
            ),
            Consumer<HomeViewModel>(
              builder: (BuildContext context, value, Widget child) {
                return Column(
                  children: [
                    ListTile(
                      title: Text('Home'),
                      leading: Icon(Icons.home),
                      onTap: () {
                        Provider.of<HomeViewModel>(context, listen: false)
                            .jumpToPage(0);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Mi perfil'),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Provider.of<HomeViewModel>(context, listen: false)
                            .jumpToPage(1);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Clientes'),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Provider.of<HomeViewModel>(context, listen: false)
                            .jumpToPage(2);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Proveedores'),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Provider.of<HomeViewModel>(context, listen: false)
                            .jumpToPage(3);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Ventas'),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Cerrar sesión'),
                      leading: Icon(Icons.power_settings_new),
                      onTap: () async {
                        bool response = await showQuestionDialog(
                            context: context,
                            title: "Importante",
                            content: "¿Estás seguro de cerrar sesión?",
                            textOk: "Si, quiero salir");
                        print("la respuesta es:$response");
                        if (response == null) return;
                        if (response) {
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyBottomNavBar extends StatefulWidget {
  MyBottomNavBar({Key key}) : super(key: key);

  @override
  _MyBottomNavBarState createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, value, Widget child) {
        return BottomNavigationBarTheme(
          data: BottomNavigationBarThemeData(backgroundColor: MyColors.accent),
          child: BottomNavyBar(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            onItemSelected: (index) {
              /*widget.pageController.animateToPage(index,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);*/

              Provider.of<HomeViewModel>(context, listen: false)
                  .jumpToPage(index);
            },
            backgroundColor: MyColors.primary.withOpacity(0.1),
            selectedIndex: value.currentPage,
            items: [
              BottomNavyBarItem(
                  icon: Icon(Icons.message),
                  title: Text('Home'),
                  activeColor: MyColors.accent,
                  inactiveColor: MyColors.secondary),
              BottomNavyBarItem(
                  icon: Icon(Icons.person_rounded),
                  title: Text('Perfil'),
                  activeColor: MyColors.accent,
                  inactiveColor: MyColors.secondary),
              BottomNavyBarItem(
                  icon: Icon(Icons.message),
                  title: Text('Clientes'),
                  activeColor: MyColors.accent,
                  inactiveColor: MyColors.secondary),
            ],
          ),
        );
      },
    );
  }
}

class MyPageView extends StatefulWidget {
  const MyPageView({Key key}) : super(key: key);

  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, value, Widget child) {
        return PageView(
          controller: value.pageController,
          onPageChanged: (index) {
            Provider.of<HomeViewModel>(context, listen: false)
                .jumpToPage(index);
          },
          children: value.listPages,
        );
      },
    );
  }
}
