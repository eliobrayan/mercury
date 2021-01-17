import 'package:flutter/material.dart';
import 'package:mercury/core/providers/auth_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/core/providers/user_provider.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';
import 'package:mercury/ui/views/register_page.dart';
import 'package:mercury/widgets/shared/buttons.dart';
import 'package:mercury/widgets/shared/dialogs.dart';
import 'package:mercury/widgets/shared/inputs.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ShowProgressDialog showLoading = ShowProgressDialog();
  bool _obscurePassword = true;
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).state =
        ProviderStates.idle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Consumer<UserProvider>(
          builder: (context, value, Widget child) {
            if (value.state == ProviderStates.done && mounted) {
              if (value.user != null) {
                print("go to home");
                //showLoading.close();
                print("cerrando el dialog");
                Provider.of<AuthProvider>(context, listen: false)
                    .getLoginStatus();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  createSnackBar(context, "Bienvenido ${value.user.name}");
                });
              }
            }

            if (value.state == ProviderStates.error) {
              //showLoading.close();
              print("error en el inicio de sesión");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                createSnackBar(context, value.errorMsg);
              });
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logoSection(),
                  loginBody(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget loginBody() {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.primaryLight,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          headerSection(),
          SizedBox(
            height: 20,
          ),
          formLogin(),
          SizedBox(
            height: 20,
          ),
          buttonsSection(),
        ],
      ),
    );
  }

  Widget formLogin() {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              loginFormInput(
                  controller: emailController,
                  hintText: "Correo eléctronico",
                  icon: Icon(Icons.person, color: MyColors.secondary),
                  inputType: TextInputType.emailAddress,
                  isPassword: false,
                  validateMode: _validate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  validatorAction: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese su correo electrónico';
                    } else if (!value
                        .contains(RegExp(r'[^@]+@[^@]+\.[a-zA-Z]'))) {
                      return "El correo ingresado no es válido";
                    } else
                      return null;
                  }),
              SizedBox(
                height: 20,
              ),
              loginFormInput(
                  controller: passwordController,
                  hintText: "Contraseña",
                  icon: Icon(
                    Icons.lock_outline,
                    color: MyColors.secondary,
                  ),
                  inputType: TextInputType.name,
                  isPassword: true,
                  validateMode: _validate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  hidePassword: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  obscureText: _obscurePassword,
                  validatorAction: (value) {
                    if (value.isEmpty) {
                      return "Ingrese su contraseña";
                    } else if (value.length < 8) {
                      return "la contraseña es muy corta";
                    } else {
                      return null;
                    }
                  }),
            ],
          ),
        )
      ],
    );
  }

  Widget buttonsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: roundedButton(
                  text: "Ingresar",
                  color: MyColors.secondary,
                  textColor: MyColors.primaryLight,
                  padding: EdgeInsets.all(15),
                  radius: 30,
                  action: () {
                    if (_formKey.currentState.validate()) {
                      print("Iniciando sesión");

                      Provider.of<UserProvider>(context, listen: false).login(
                          emailController.text.trim(),
                          passwordController.text.trim());
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        createSnackBar(context, "Iniciando sesión");
                      });
                      //showLoading.showLoadingDialog(
                      //  context, "Iniciando sesión");
                    } else {
                      setState(() {
                        _validate = true;
                      });
                    }
                  }),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: roundedButton(
                  text: "Crear Nueva Cuenta",
                  color: MyColors.accent,
                  textColor: MyColors.primaryLight,
                  border: true,
                  padding: EdgeInsets.all(15),
                  radius: 30,
                  borderColor: MyColors.light,
                  borderWidth: 0.1,
                  action: () {
                    print("Go to register page");
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new RegisterPage()));
                  }),
            ),
          ],
        ),
      ],
    );
  }

  Widget logoSection() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Image.asset("assets/images/logoTemp.png"),
    );
  }

  Widget headerSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bienvenido",
          style: TextStyle(
            color: MyColors.accent,
            fontSize: MySizes.title6,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Inicia Sesión",
          style: TextStyle(
            fontSize: MySizes.title6,
            color: MyColors.light,
          ),
        ),
      ],
    );
  }
}
