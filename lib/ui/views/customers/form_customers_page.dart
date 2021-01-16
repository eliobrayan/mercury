import 'package:flutter/material.dart';
import 'package:mercury/core/providers/crud_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';
import 'package:mercury/models/customer_model.dart';
import 'package:mercury/widgets/shared/buttons.dart';
import 'package:mercury/widgets/shared/dialogs.dart';
import 'package:mercury/widgets/shared/inputs.dart';
import 'package:mercury/widgets/shared/widgets.dart';
import 'package:provider/provider.dart';

class FormCustomerPage extends StatefulWidget {
  FormCustomerPage({Key key, this.customer}) : super(key: key);
  final CustomerModel customer;
  @override
  _FormCustomerPageState createState() => _FormCustomerPageState();
}

class _FormCustomerPageState extends State<FormCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController lastNameController;
  TextEditingController addressController;
  TextEditingController referenceController;
  TextEditingController phoneController;
  TextEditingController typeController;
  bool _validate = false;
  @override
  void initState() {
    super.initState();
    Provider.of<CRUDProvider>(context, listen: false).state =
        ProviderStates.idle;
    nameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    referenceController = TextEditingController();
    phoneController = TextEditingController();
    typeController = TextEditingController();
    if (widget.customer != null) {
      nameController.text = widget.customer.name ?? "";
      lastNameController.text = widget.customer.lastName ?? "";
      addressController.text = widget.customer.address ?? "";
      phoneController.text = widget.customer.phone ?? "";
      typeController.text = widget.customer.type ?? "";
      referenceController.text = widget.customer.reference ?? "";
    }
  }

  List<String> listCustomerTypes = [
    "Normal",
    "Restaurante",
    "Tienda",
    "Casero"
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<CRUDProvider>(
          builder: (BuildContext context, value, Widget child) {
            if (value.state == ProviderStates.error) {
              print("error al crear un cliente");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                createSnackBar(context, value.msgError);
              });
            }
            if (value.state == ProviderStates.done) {
              print("Cliente creado");
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
              controller: addressController,
              inputType: TextInputType.text,
              hintText: "Dirección",
              icon: Icon(Icons.room),
              validateMode: _validate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validatorAction: (value) {
                if (value.isEmpty) {
                  return "Ingrese una dirección";
                } else {
                  return null;
                }
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
          DropdownButtonFormField(
            onChanged: (value) {
              print(value);
              typeController.text = value;
            },
            iconEnabledColor: MyColors.accent,
            focusColor: MyColors.accent,
            value: widget.customer != null
                ? widget.customer.type != ""
                    ? widget.customer.type
                    : listCustomerTypes[0]
                : listCustomerTypes[0],
            dropdownColor: MyColors.primaryLight,
            items: listCustomerTypesItems(),
            style: TextStyle(
                fontSize: MySizes.body2,
                fontStyle: FontStyle.italic,
                color: MyColors.secondary),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.secondary),
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.person_pin),
                isDense: true,
                focusColor: MyColors.accent),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> listCustomerTypesItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String type in listCustomerTypes) {
      items.add(new DropdownMenuItem(value: type, child: Text(type)));
    }
    return items;
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
              text: widget.customer != null ? "Actualizar" : "Crear",
              radius: 30,
              //margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 15),
              action: () {
                if (_formKey.currentState.validate()) {
                  DateTime createDate = DateTime.now();
                  CustomerModel customer = CustomerModel(
                      name: nameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      address: addressController.text.trim(),
                      reference: referenceController.text.trim(),
                      phone: phoneController.text.trim(),
                      type: typeController.text.trim(),
                      createDate: createDate);
                  if (widget.customer != null) {
                    print("Actualizando cliente");
                    Provider.of<CRUDProvider>(context, listen: false)
                        .updateEntity(
                            customer, "customers", widget.customer.id);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      createSnackBar(context1, "Actualizando cliente");
                    });
                  } else {
                    print("Creando cliente");
                    Provider.of<CRUDProvider>(context, listen: false)
                        .createEntity(customer, "customers");
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      createSnackBar(context1, "Creando cliente");
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
