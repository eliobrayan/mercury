import 'package:flutter/material.dart';
import 'package:mercury/core/providers/crud_provider.dart';
import 'package:mercury/core/providers/enum_states.dart';
import 'package:mercury/misc/colors.dart';
import 'package:mercury/misc/sized.dart';
import 'package:mercury/models/ballooms_model.dart';
import 'package:mercury/models/customer_model.dart';
import 'package:mercury/widgets/shared/buttons.dart';
import 'package:mercury/widgets/shared/dialogs.dart';
import 'package:mercury/widgets/shared/inputs.dart';
import 'package:mercury/widgets/shared/widgets.dart';
import 'package:provider/provider.dart';

class FormBalloomsPage extends StatefulWidget {
  FormBalloomsPage({Key key, this.balloom}) : super(key: key);
  final BalloomsModel balloom;
  @override
  _FormBalloomsPageState createState() => _FormBalloomsPageState();
}

class _FormBalloomsPageState extends State<FormBalloomsPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController priceSaleController;
  TextEditingController priceBuyController;
  TextEditingController weigthController;  
  TextEditingController typeController;
  bool _validate = false;
  @override
  void initState() {
    super.initState();
    Provider.of<CRUDProvider>(context, listen: false).state =
        ProviderStates.idle;
    nameController = TextEditingController();
    priceSaleController = TextEditingController();
    priceBuyController = TextEditingController();
    weigthController = TextEditingController();
    typeController = TextEditingController();
    typeController = TextEditingController();
    if (widget.balloom != null) {
      nameController.text = widget.balloom.name ?? "";
      
      priceBuyController.text = widget.balloom.priceBuy.toStringAsFixed(2) ?? "";
      priceSaleController.text = widget.balloom.priceSale.toStringAsFixed(2) ?? "";
      typeController.text = widget.balloom.type ?? "";
      weigthController.text = widget.balloom.weight.toStringAsFixed(2) ?? "";
    }
  }

  List<String> listBalloomTypes = [
    "Normal",
    "Premium",
    "Grande",
    "Pequeño"
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<CRUDProvider>(
          builder: (BuildContext context, value, Widget child) {
            if (value.state == ProviderStates.error) {
              print("error al crear el balón");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                createSnackBar(context, value.msgError);
              });
            }
            if (value.state == ProviderStates.done) {
              print("Balón creado");
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
              controller: weigthController,
              inputType: TextInputType.name,
              hintText: "Peso",
              icon: Icon(Icons.person_pin),
              validateMode: _validate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validatorAction: (value) {
                if (value.isEmpty) {
                  return "Ingrese un peso";
                } else {
                  return null;
                }
              }),
          SizedBox(
            height: 10,
          ),
          formInput(
              controller: priceBuyController,
              inputType: TextInputType.text,
              hintText: "Precio de compra",
              icon: Icon(Icons.room),
              validateMode: _validate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validatorAction: (value) {
                if (value.isEmpty) {
                  return "Ingrese un precio de compra";
                } else {
                  return null;
                }
              }),
          SizedBox(
            height: 10,
          ),
           formInput(
              controller: priceSaleController,
              inputType: TextInputType.text,
              hintText: "Precio de venta",
              icon: Icon(Icons.room),
              validateMode: _validate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validatorAction: (value) {
                if (value.isEmpty) {
                  return "Ingrese un precio de venta";
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
            value: widget.balloom != null
                ? widget.balloom.type != ""
                    ? widget.balloom.type
                    : listBalloomTypes[0]
                : listBalloomTypes[0],
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
    for (String type in listBalloomTypes) {
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
              text: widget.balloom != null ? "Actualizar" : "Crear",
              radius: 30,
              //margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 15),
              action: () {
                if (_formKey.currentState.validate()) {
                  
                  BalloomsModel customer = BalloomsModel(
                      name: nameController.text.trim(),
                      type: typeController.text.trim(),
                      weight:double.parse( weigthController.text.trim()),
                      priceBuy: double.parse( priceBuyController.text.trim()),
                      priceSale: double.parse( priceSaleController.text.trim()),
                      );
                  if (widget.balloom != null) {
                    print("Actualizando balón");
                    Provider.of<CRUDProvider>(context, listen: false)
                        .updateEntity(
                            customer, "ballooms", widget.balloom.id);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      createSnackBar(context1, "Actualizando balón");
                    });
                  } else {
                    print("Creando balón");
                    Provider.of<CRUDProvider>(context, listen: false)
                        .createEntity(customer, "ballooms");
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      createSnackBar(context1, "Creando balón");
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
