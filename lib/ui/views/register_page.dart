import 'package:flutter/material.dart';
import 'package:mercury/core/providers/auth_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/core/providers/user_provider.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';
import 'package:mercury/widgets/shared/buttons.dart';
import 'package:mercury/widgets/shared/dialogs.dart';
import 'package:mercury/widgets/shared/inputs.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
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
        appBar: AppBar(
          title: Text("Registro"),
        ),
        key: Key("Register"),
        body: Container(
          alignment: Alignment.center,

          //color: MyColors.primary,
          child: Consumer<UserProvider>(
            builder: (context, value, Widget child) {
              print(value.state);
              if (value.state == ProviderStates.done) {
                if (value.user != null) {
                  print("go to home");
                  //showLoading.close();
                  Provider.of<AuthProvider>(context, listen: false)
                      .getLoginStatus();
                  Navigator.pop(context);
                }
              }

              if (value.state == ProviderStates.error) {
                showLoading.close();
                print("error en la creación del usuario");
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  createSnackBar(context, value.errorMsg);
                });
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    logoSection(),
                    loginBody(context),
                  ],
                ),
              );
            },
          ),
        ));
  }

  Widget loginBody(BuildContext context1) {
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
          buttonsSection(context1),
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
                  controller: nameController,
                  hintText: "Nombres",
                  icon: Icon(Icons.person, color: MyColors.secondary),
                  inputType: TextInputType.name,
                  isPassword: false,
                  validateMode: _validate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  validatorAction: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese su nombre';
                    } else
                      return null;
                  }),
              SizedBox(
                height: 20,
              ),
              loginFormInput(
                  controller: lastNameController,
                  hintText: "Apellidos",
                  icon: Icon(Icons.person, color: MyColors.secondary),
                  inputType: TextInputType.name,
                  isPassword: false,
                  validateMode: _validate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  validatorAction: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese su apellido';
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
                },
              ),
              SizedBox(
                height: 20,
              ),
              loginFormInput(
                controller: repeatPasswordController,
                hintText: "Confirmar contraseña",
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
                    return "Ingrese una contraseña";
                  } else if (value != passwordController.text) {
                    return "las contraseñas no coinciden";
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buttonsSection(BuildContext context1) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: roundedButton(
                  text: "Registrar",
                  color: MyColors.secondary,
                  textColor: MyColors.primaryLight,
                  padding: EdgeInsets.all(15),
                  radius: 30,
                  action: () {
                    if (_formKey.currentState.validate()) {
                      print("Registrando");
                      Provider.of<UserProvider>(context, listen: false)
                          .createUser(
                              emailController.text.trim(),
                              nameController.text.trim(),
                              lastNameController.text.trim(),
                              passwordController.text.trim());
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        createSnackBar(context1, "Registrando");
                      });
                      // showLoading.showLoadingDialog(context, "Registrando");
                      //FocusScope.of(context).unfocus();
                    } else {
                      setState(() {
                        _validate = true;
                      });
                    }
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
