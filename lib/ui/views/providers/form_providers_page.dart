import 'package:flutter/material.dart';
import 'package:mercury/core/providers/crud_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/models/provider_model.dart';
import 'package:mercury/widgets/shared/buttons.dart';
import 'package:mercury/widgets/shared/dialogs.dart';
import 'package:mercury/widgets/shared/inputs.dart';
import 'package:mercury/widgets/shared/widgets.dart';
import 'package:provider/provider.dart';

class FormProvidersPage extends StatefulWidget {
  FormProvidersPage({Key key, this.provider}) : super(key: key);
  final ProviderModel provider;
  @override
  _FormProvidersPageState createState() => _FormProvidersPageState();
}

class _FormProvidersPageState extends State<FormProvidersPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController lastNameController;
  TextEditingController referenceController;
  TextEditingController phoneController;
  bool _validate = false;
  @override
  void initState() {
    super.initState();
    Provider.of<CRUDProvider>(context, listen: false).state =
        ProviderStates.idle;
    nameController = TextEditingController();
    lastNameController = TextEditingController();

    referenceController = TextEditingController();
    phoneController = TextEditingController();
    if (widget.provider != null) {
      nameController.text = widget.provider.name ?? "";
      lastNameController.text = widget.provider.lastName ?? "";
      phoneController.text = widget.provider.phone ?? "";
      referenceController.text = widget.provider.reference ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<CRUDProvider>(
          builder: (BuildContext context, value, Widget child) {
            if (value.state == ProviderStates.error) {
              print("error al crear un proveedor");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                createSnackBar(context, value.msgError);
              });
            }
            if (value.state == ProviderStates.done) {
              print("Proveedor creado");
              Navigator.of(context).pop(true);
            }

            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    headerForms(imageUrl: "assets/images/logoTemp.png"),
                    SizedBox(
                      height: 20,
                    ),
                    form(),
                    SizedBox(
                      height: 20,
                    ),
                    buttonSection(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          formInput(
              controller: nameController,
              inputType: TextInputType.name,
              hintText: "Nombres",
              icon: Icon(Icons.person),
              validateMode: _validate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validatorAction: (value) {
                if (value.isEmpty) {
                  return "Ingrese un nombre";
                } else {
                  return null;
                }
              }),
          SizedBox(
            height: 10,
          ),
          formInput(
              controller: lastNameController,
              inputType: TextInputType.name,
              hintText: "Apellidos",
              icon: Icon(Icons.person_pin),
              validateMode: _validate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validatorAction: (value) {
                return null;
              }),
          SizedBox(
            height: 10,
          ),
          formInput(
              controller: referenceController,
              inputType: TextInputType.text,
              hintText: "referencia",
              icon: Icon(Icons.home),
              validateMode: _validate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validatorAction: (value) {
                return null;
              }),
          SizedBox(
            height: 10,
          ),
          formInput(
              controller: phoneController,
              inputType: TextInputType.phone,
              hintText: "Teléfono",
              icon: Icon(Icons.phone),
              validateMode: _validate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validatorAction: (value) {
                if (value.isNotEmpty) {
                  if (!value.contains(RegExp(r'^9([0-9]){8}$'))) {
                    return "El número de teléfono no es válido";
                  } else {
                    return null;
                  }
                } else {
                  return null;
                }
              }),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget buttonSection(BuildContext context1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: formButton(
              isOutlined: true,
              borderColor: MyColors.accent,
              text: "Cancelar",
              radius: 30,
              padding: EdgeInsets.symmetric(vertical: 15),
              //margin: EdgeInsets.symmetric(horizontal: 30),
              action: () {
                Navigator.of(context).pop();
              }),
        ),
        SizedBox(width: 20),
        Expanded(
          child: formButton(
              fillColor: MyColors.secondary,
              text: widget.provider != null ? "Actualizar" : "Crear",
              radius: 30,
              //margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 15),
              action: () {
                if (_formKey.currentState.validate()) {
                  ProviderModel provider = ProviderModel(
                    name: nameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    reference: referenceController.text.trim(),
                    phone: phoneController.text.trim(),
                  );
                  if (widget.provider != null) {
                    print("Actualizando proveedor");
                    Provider.of<CRUDProvider>(context, listen: false)
                        .updateEntity(
                            provider, "providers", widget.provider.id);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      createSnackBar(context1, "Actualizando proveedor");
                    });
                  } else {
                    print("Creando proveedor");
                    Provider.of<CRUDProvider>(context, listen: false)
                        .createEntity(provider, "providers");
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      createSnackBar(context1, "Creando proveedor");
                    });
                  }

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
    );
  }
}
