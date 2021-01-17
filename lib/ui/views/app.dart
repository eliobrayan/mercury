import 'package:flutter/material.dart';
import 'package:mercury/core/providers/auth_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/ui/views/home_page.dart';
import 'package:mercury/ui/views/login_page.dart';
import 'package:mercury/ui/views/splash_page.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    Provider.of<AuthProvider>(context, listen: false).getLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (BuildContext context, value, Widget child) {
            if (value.state == ProviderStates.error) {
              return Center(child: Text(value.errorMsg));
            } else if (value.state == ProviderStates.done) {
              if (value.userFirebase != null) {
                print("user exists");
                return HomePage();
              } else {
                print("to login page");
                return LoginPage();
              }
            }

            return SplashPage();
          },
          //child: MyDrawer())),
        ),
      ),
    );
  }
}
