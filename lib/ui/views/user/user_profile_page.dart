import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/core/providers/user_provider.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';
import 'package:mercury/models/user_model.dart';
import 'package:mercury/widgets/shared/buttons.dart';
import 'package:mercury/widgets/shared/dialogs.dart';
import 'package:mercury/widgets/shared/inputs.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  UserModel user;
  bool _validate = false;
  bool _validatePasswords = false;
  bool editing = false;
  bool editingPassword = false;
  bool _obscurePassword = false;
  final _formKey = GlobalKey<FormState>();
  final _formPasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (BuildContext context, value, Widget child) {
          print(value.state);

          if (value.state == ProviderStates.error) {
            print("errorrrrrr");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              createSnackBar(context, value.errorMsg);
              Provider.of<UserProvider>(context).errorMsg = null;
            });
          }
          if (value.state == ProviderStates.done) {
            if (value.msg != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                createSnackBar(context, value.msg);
                Provider.of<UserProvider>(context).msg = null;
              });
            }
          }
          if (value.user != null) {
            emailController.text = value.user.email;
            nameController.text = value.user.name;
            lastNameController.text = value.user.lastName;
            user = value.user;
            return bodyProfile();
          } else {
            Provider.of<UserProvider>(context, listen: false).getCurrentUser();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitDualRing(color: MyColors.accent),
            ],
          );
        },
      ),
    );
  }

  Widget bodyProfile() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            headerSection(),
            SizedBox(
              height: 20,
            ),
            dataSection(),
            SizedBox(
              height: 20,
            ),
            buttonSection(),
            SizedBox(
              height: 20,
            ),
            buttonChangePassword(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget headerSection() {
    return Column(
      children: [
        Image.asset(
          "assets/images/profile.png",
          width: 250,
          height: 250,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hola ",
              style: TextStyle(fontSize: MySizes.title6),
            ),
            Text(
              "${user.name}!",
              style:
                  TextStyle(fontSize: MySizes.title6, color: MyColors.accent),
            ),
          ],
        )
      ],
    );
  }

  Widget dataSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
              "Datos Personales",
              style: TextStyle(color: MyColors.secondary),
            )),
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: MyColors.secondary,
                ),
                onPressed: () {
                  setState(() {
                    editing = !editing;
                  });
                })
          ],
        ),
        Divider(),
        SizedBox(
          height: 15,
        ),
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
            ],
          ),
        )
      ],
    );
  }

  Widget buttonChangePassword() {
    return Column(
      children: [
        Visibility(
          child: Divider(),
          visible: editingPassword,
        ),
        Visibility(
          visible: editingPassword,
          child: Form(
            key: _formPasswordKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                loginFormInput(
                  controller: oldPasswordController,
                  hintText: "Contraseña anterior",
                  icon: Icon(
                    Icons.lock_outline,
                    color: MyColors.secondary,
                  ),
                  inputType: TextInputType.name,
                  isPassword: true,
                  validateMode: _validatePasswords
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
                  controller: passwordController,
                  hintText: "Nueva contraseña",
                  icon: Icon(
                    Icons.lock_outline,
                    color: MyColors.secondary,
                  ),
                  inputType: TextInputType.name,
                  isPassword: true,
                  validateMode: _validatePasswords
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
                  validateMode: _validatePasswords
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
          ),
        ),
        Divider(),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            roundedButton(
                text: editingPassword
                    ? "Cambiar contraseña"
                    : "Actualizar contraseña",
                color: MyColors.accent,
                textColor: MyColors.primaryLight,
                padding: EdgeInsets.all(15),
                radius: 30,
                action: () async {
                  print("Change password");
                  if (editingPassword) {
                    if (_formPasswordKey.currentState.validate()) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        createSnackBar(context, "Actualizando contraseña");
                      });
                      Provider.of<UserProvider>(context, listen: false)
                          .updatePassword(passwordController.text.trim(),
                              oldPasswordController.text.trim());
                      editingPassword = false;
                    } else {
                      _validatePasswords = true;
                    }
                  } else {
                    setState(() {
                      editingPassword = true;
                    });
                  }
                }),
            SizedBox(
              width: 20,
            ),
            Visibility(
              visible: editingPassword,
              child: roundedButton(
                  text: "Cancelar",
                  color: MyColors.secondary,
                  textColor: MyColors.primaryLight,
                  padding: EdgeInsets.all(15),
                  radius: 30,
                  action: () {
                    setState(() {
                      editingPassword = false;
                    });
                  }),
            )
          ],
        ),
      ],
    );
  }

  Widget buttonSection() {
    return Visibility(
      visible: editing,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          roundedButton(
              text: "Actualizar datos",
              color: MyColors.secondary,
              textColor: MyColors.primaryLight,
              padding: EdgeInsets.all(15),
              radius: 30,
              action: () {
                if (_formKey.currentState.validate()) {
                  print("Registrando");
                  UserModel newUser = UserModel(
                      email: emailController.text.trim(),
                      name: nameController.text.trim(),
                      lastName: lastNameController.text.trim());
                  Provider.of<UserProvider>(context, listen: false)
                      .updateUser(newUser);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    createSnackBar(context, "Actualizando datos");
                  });
                  // showLoading.showLoadingDialog(context, "Registrando");
                  //FocusScope.of(context).unfocus();
                } else {
                  setState(() {
                    _validate = true;
                  });
                }
              }),
        ],
      ),
    );
  }

  Widget messageError(String messg) {
    return Column(
      children: [
        Text(
          messg,
          style:
              TextStyle(color: MyColors.errorLight, fontSize: MySizes.subTitle),
        ),
        SizedBox(
          height: 20,
        ),
        MaterialButton(onPressed: () {
          Provider.of<UserProvider>(context, listen: false).getCurrentUser();
        }),
      ],
    );
  }
}
