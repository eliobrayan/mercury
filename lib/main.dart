import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mercury/core/providers/auth_provider.dart';
import 'package:mercury/core/providers/crud_provider.dart';
import 'package:mercury/core/providers/customers_provider.dart';
import 'package:mercury/core/providers/home_view_model.dart';
import 'package:mercury/core/providers/register_provider.dart';
import 'package:mercury/core/providers/user_provider.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/fonts.dart';
import 'package:mercury/ui/views/app.dart';
import 'package:mercury/ui/views/home_page.dart';
import 'package:mercury/ui/views/login_page.dart';
import 'package:mercury/ui/views/register_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => CRUDProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CustomersProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Mercury',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: MyColors.primary,
          primaryColor: MyColors.primary,
          hintColor: MyColors.secondary,
          accentColor: MyColors.accent,
          brightness: Brightness.dark,
          fontFamily: MyFonts.fontPrimary,
          errorColor: MyColors.errorLight,
          focusColor: MyColors.accent,
          cursorColor: MyColors.accent,
          splashColor: MyColors.coral.withOpacity(0.6),
          dividerColor: MyColors.secondary,
          indicatorColor: MyColors.secondary,
          textSelectionColor: MyColors.accent,
          textSelectionHandleColor: MyColors.accent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/': (context) => App(),
          'login': (context) => LoginPage(),
          'Home': (context) => HomePage(),
          'Register': (context) => RegisterPage(),
        },
        initialRoute: '/',
        /*home: MultiProvider(providers: [
          Provider<UserProvider>(
            create: (_) => UserProvider()..getLoginStatus(),
          ),
        ], child: LoginPage()),*/
      ),
    );
  }
}
